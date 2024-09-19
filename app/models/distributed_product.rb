class DistributedProduct < ApplicationRecord
  belongs_to :distribution
  belongs_to :packaged_product
  belongs_to :region

  has_one :generation, dependent: :destroy

  validates_presence_of :production_date
  validates :count, presence: true, numericality: { only_integer: true }

  scope :filter_by_region, ->(region_id) { where(region_id: region_id) }
  scope :filter_by_product, ->(product_id) { joins(:packaged_product).where(packaged_products: { product_id: product_id }) }

  scope :without_current_batch, ->(batch_id) { joins(:distribution).where.not(distributions: { batch_id: batch_id }) }

  scope :ordered, -> { order(region_id: :desc) }
end
