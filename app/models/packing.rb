class Packing < ApplicationRecord
  include Progressable

  belongs_to :batch

  has_many :products, class_name: "PackagedProduct", foreign_key: "packing_id", dependent: :destroy
  accepts_nested_attributes_for :products

  def build_products
    plan = batch.production_unit.plan
    products.build(plan.products.filter_by_group(batch.production_unit.group.id).map { |product| { packing: self, product: product, count: plan.product_sum(product) } })
  end
end
