class Product < ApplicationRecord
  belongs_to :group
  belongs_to :measurement

  has_many :prices, dependent: :destroy
  has_many :custom_prices, dependent: :destroy
  has_many :box_packagings, dependent: :destroy
  has_many :single_packagings, dependent: :destroy

  has_many :discounts, class_name: "DiscountedProduct", foreign_key: "product_id", dependent: :destroy
  has_many :packages, class_name: "PackagedProduct", foreign_key: "product_id", dependent: :destroy
  has_many :positions, dependent: :destroy

  has_many :boxes, dependent: :destroy

  has_many :leftovers, as: :subject, dependent: :destroy

  has_many :tracking_products, dependent: :destroy

  has_many :returned_products, dependent: :destroy

  has_many :estimations, dependent: :destroy

  validates :name, :article, presence: true, uniqueness: { case_sensitive: false }
  validates_presence_of :packing, :expiration_in_days, :fat_fraction
  validates_numericality_of :fat_fraction, in: 0.0..100.0

  scope :filter_by_group, ->(group_id) { where(group_id: group_id) }

  scope :ordered, -> { order(name: :asc) }

  def price(by:, client: nil)
    if client
      base_price = custom_prices.active.find_by client_id: client
      return base_price if base_price.present?
    end

    base_price = prices.active.find_by(sales_channel_id: by)
    base_price.presence || Price.new(value: 0.0)
  end

  def tonnage(count)
    total = count * self.packing
    total > 0.0 ? measurement.to_tonnage_ratio(total) : 0.0
  end

  def name_with_article
    "#{ article } - #{ name }"
  end
end
