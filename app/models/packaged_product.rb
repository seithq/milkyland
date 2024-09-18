class PackagedProduct < ApplicationRecord
  belongs_to :packing
  belongs_to :product

  has_many :distributed_products, dependent: :destroy

  validates_uniqueness_of :product_id, scope: :packing_id
  validates :count, presence: true, numericality: { only_integer: true }

  scope :filter_by_product, ->(product_id) { where(product_id: product_id) }

  scope :without_current_batch, ->(batch_id) { joins(:packing).where.not(packings: { batch_id: batch_id }) }
end
