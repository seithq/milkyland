class Plan < ApplicationRecord
  SHARED = %w[ ready_to_production in_production produced cancelled ]

  has_many :consolidations, dependent: :destroy
  has_many :orders, -> { merge(Consolidation.active) }, through: :consolidations
  has_many :positions, through: :orders
  has_many :products, through: :positions
  has_many :groups, through: :products

  has_many :sales_points, through: :orders
  has_many :regions, through: :sales_points

  has_many :units, class_name: "ProductionUnit", foreign_key: "plan_id", dependent: :destroy, inverse_of: :plan
  accepts_nested_attributes_for :units
  has_many :batches, through: :units
  has_many :unit_groups, class_name: "Group", through: :units, source: :group

  has_many :packings, through: :batches
  has_many :packaged_products, through: :packings, source: :products

  has_many :cookings, through: :batches
  has_many :cooked_semi_products, through: :cookings, source: :semi_products

  has_many :distributions, through: :batches
  has_many :distributed_products, through: :distributions, source: :products

  after_update :call_update_callbacks

  validates :production_date, presence: true, comparison: { greater_than_or_equal_to: Time.zone.today }

  enum :kind, %w[ standard semi ].index_by(&:itself), default: :standard
  enum :status, (%w[ in_consolidation ] + SHARED).index_by(&:itself), default: :in_consolidation

  scope :filter_by_kind, ->(kind) { where(kind: kind) }
  scope :filter_by_status, ->(status) { where(status: status) }

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

  def semi_group_sum
    self.units.sum(:count)
  end

  def group_tonnage(group)
    scope = self.positions.filter_by_group(group.id)
    total = scope.sum("positions.count * products.packing")
    total > 0.0 ? scope.first.product.measurement.to_tonnage_ratio(total) : 0.0
  end

  def semi_group_tonnage
    self.units.sum(:tonnage)
  end

  def group_products(group)
    self.products.filter_by_group(group.id).uniq
  end

  def group_semi_products(group)
    SemiProduct.filter_by_group(group.id).uniq
  end

  def product_sum(product)
    self.positions.filter_by_product(product.id).sum(:count)
  end

  def product_remaining_sum(product)
    total = self.positions.filter_by_product(product).sum(:count)
    packed = self.packaged_products.filter_by_product(product.id).approved.sum(:count)
    total.zero? ? 0 : [ 0, total - packed ].max
  end

  @deprecated
  def product_region_remaining_sum(batch, region, product)
    total = self.product_region_sum(region, product)
    packed = self.distributed_products.filter_by_product(product.id).without_current_batch(batch.id).sum(:count)
    total.zero? ? 0 : total - packed
  end

  def product_region_produced_sum(region, product)
    self.distributed_products.filter_by_region(region.id).filter_by_product(product.id).sum(:count)
  end

  def product_region_sum(region, product)
    Position.filter_by_product(product)
            .where(order_id: self.orders.filter_by_region(region.id))
            .sum(:count)
  end

  def product_tonnage(product)
    scope = self.positions.filter_by_product(product.id)
    total = scope.sum("positions.count * products.packing")
    total > 0.0 ? scope.first.product.measurement.to_tonnage_ratio(total) : 0.0
  end

  def count
    self.positions.sum(:count)
  end

  def produced_count
    self.packaged_products.approved.sum(:count)
  end

  def can_edit?
    in_consolidation?
  end

  def progress
    (produced_count.to_d / count.to_d) * 100.0
  end

  private
    def update_orders
      orders.update_all status: self.status
    end

    def create_production_units
      return unless in_production?

      transaction do
        unit_attributes = self.groups.uniq.map { |group| { group_id: group.id, count: group_sum(group), tonnage: group_tonnage(group) } }
        self.units.create!(unit_attributes)
      end
    end

    def call_update_callbacks
      return unless SHARED.include? status
      return unless status_previously_changed?

      update_orders
      create_production_units
    end
end
