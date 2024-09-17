class PackagedProduct < ApplicationRecord
  belongs_to :packing
  belongs_to :product

  validates_uniqueness_of :product_id, scope: :packing_id
  validates :count, presence: true, numericality: { only_integer: true }

  scope :filter_by_product, ->(product_id) { where(product_id: product_id) }
end
