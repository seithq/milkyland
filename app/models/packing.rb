class Packing < ApplicationRecord
  include Progressable

  belongs_to :batch

  has_many :products, class_name: "PackagedProduct", foreign_key: "packing_id", dependent: :destroy
  accepts_nested_attributes_for :products

  def build_products
    plan = batch.production_unit.plan
    products.build(plan.group_products(batch.production_unit.group).map { |product| { packing: self, product: product, count: plan.product_remaining_sum(product) } })
  end

  def packed_count(product_id: nil)
    scope = products
    scope = scope.filter_by_product(product_id) if product_id
    scope.sum(:count)
  end
end
