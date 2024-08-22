class DiscountedProduct < ApplicationRecord
  include Deactivatable

  belongs_to :promotion
  belongs_to :product

  validates_uniqueness_of :product_id, scope: :promotion_id
end
