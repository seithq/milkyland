class DistributedProduct < ApplicationRecord
  belongs_to :distribution
  belongs_to :packaged_product
  belongs_to :region

  validates_presence_of :production_date
  validates :count, presence: true, numericality: { only_integer: true }

  scope :filter_by_product, ->(product_id) { joins(:packaged_product).where(packaged_products: { product_id: product_id }) }
end
