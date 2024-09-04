class Promotion < ApplicationRecord
  include Deactivatable

  has_many :participants, dependent: :destroy
  has_many :products, class_name: "DiscountedProduct", foreign_key: "promotion_id", dependent: :destroy
  has_many :positions, dependent: :nullify

  enum :kind, %w[ by_percent by_amount ].index_by(&:itself), default: :by_percent

  before_validation :normalize_dates

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :discount, presence: true, numericality: { greater_than: 0.0 }
  validates_presence_of :start_date, :end_date, unless: :unlimited?

  scope :running, ->(date: Time.zone.today) { active.where(unlimited: true).or(Promotion.where(start_date: ..date, end_date: date..)) }

  scope :filter_by_eligible, ->(client_id:, product_id:) do
    ids = filter_by_product(product_id).filter_by_client(client_id).pluck(:id)
    ids += filter_by_missing_clients.filter_by_product(product_id).pluck(:id)
    ids += filter_by_missing_products.filter_by_client(client_id).pluck(:id)
    where(id: ids)
  end

  scope :filter_by_product, ->(product_id) { joins(:products).where(products: { product_id: product_id }) }
  scope :filter_by_client, ->(client_id) { joins(:participants).where(participants: { client_id: client_id }) }

  scope :filter_by_missing_products, ->() { where.missing(:products) }
  scope :filter_by_missing_clients, ->() { where.missing(:participants) }

  def running?
    return true if unlimited?

    Time.zone.today.between?(start_date, end_date)
  end

  def can_be_stopped?
    active? && running?
  end

  def calculate_discount_for(price)
    if by_percent?
      price.value * (100.0 - discount) / 100.0
    else
      [ price.value - discount, 0.0 ].max
    end
  end

  private
    def normalize_dates
      return unless unlimited?

      self.start_date, self.end_date = nil, nil
    end
end
