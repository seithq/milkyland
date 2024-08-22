class Product < ApplicationRecord
  belongs_to :group
  belongs_to :measurement
  belongs_to :material_asset, -> { packings }

  has_many :prices, dependent: :destroy
  has_many :discounts, class_name: "DiscountedProduct", foreign_key: "product_id", dependent: :destroy

  validates :name, :article, presence: true, uniqueness: { case_sensitive: false }
  validates_presence_of :packing, :expiration_in_days, :fat_fraction
  validates_numericality_of :fat_fraction, in: 0.0..100.0

  scope :ordered, -> { order(name: :asc) }

  def price(by:)
    channel = prices.find_by(sales_channel_id: by)
    channel ? channel.value : 0.0
  end
end
