class Plan < ApplicationRecord
  SHARED = %w[ ready_to_production in_production produced cancelled ]

  has_many :consolidations, dependent: :destroy
  has_many :orders, -> { merge(Consolidation.active) }, through: :consolidations
  has_many :positions, through: :orders
  has_many :products, through: :positions
  has_many :groups, through: :products

  after_update :update_orders

  validates :production_date, presence: true, comparison: { greater_than_or_equal_to: Time.zone.today }

  enum :status, (%w[ in_consolidation ] + SHARED).index_by(&:itself), default: :in_consolidation

  scope :filter_by_status, ->(status) { where status: status }

  scope :ordered, -> { order(production_date: :desc) }

  # Для табов во вкладке производства
  scope :active,    -> { filter_by_status(%i[ ready_to_production in_production ]) }
  scope :completed, -> { filter_by_status(%i[ produced cancelled ]) }

  def self.after(from_date)
    Plan.where(status: :in_consolidation, production_date: (from_date + 1.day)..).order(production_date: :asc).first
  end

  def cancel(comment: "")
    update status: :cancelled, comment: comment
  end

  def add(order)
    self.consolidations.create! order: order
  end

  def group_sum(group)
    self.positions.filter_by_group(group.id).sum(:count)
  end

  def group_tonnage(group)
    scope = self.positions.filter_by_group(group.id)
    total = scope.sum("positions.count * products.packing")
    total > 0.0 ? scope.first.product.measurement.to_tonnage_ratio(total) : 0.0
  end

  def group_products(group)
    self.products.filter_by_group(group.id).uniq
  end

  def product_sum(product)
    self.positions.filter_by_product(product.id).sum(:count)
  end

  def product_tonnage(product)
    scope = self.positions.filter_by_product(product.id)
    total = scope.sum("positions.count * products.packing")
    total > 0.0 ? scope.first.product.measurement.to_tonnage_ratio(total) : 0.0
  end

  def can_edit?
    in_consolidation?
  end

  def progress
    20.0
  end

  private
    def update_orders
      return unless SHARED.include? status

      orders.update_all status: self.status if status_previously_changed?
    end
end
