class CookedSemiProduct < ApplicationRecord
  belongs_to :cooking
  belongs_to :semi_product

  validates_uniqueness_of :semi_product_id, scope: :cooking_id
  validates :litrage, presence: true, numericality: { greater_than: 0.0 }

  scope :filter_by_group, ->(group_id) { joins(semi_product: :group).merge(SemiProduct.filter_by_group(group_id)) }
  scope :filter_by_semi_product, ->(semi_product_id) { where(semi_product_id: semi_product_id) }

  scope :approved, -> { joins(:cooking).merge(Cooking.filter_by_status(:completed)) }
end
