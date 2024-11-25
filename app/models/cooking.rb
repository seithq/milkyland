class Cooking < ApplicationRecord
  include Progressable

  belongs_to :batch

  has_many :semi_products, class_name: "CookedSemiProduct", foreign_key: "cooking_id", dependent: :destroy
  accepts_nested_attributes_for :semi_products

  def build_semi_products
    plan = batch.production_unit.plan
    semi_products.build(plan.group_semi_products(batch.production_unit.group).map { |semi_product| { cooking: self, semi_product: semi_product, tonnage: batch.production_unit.tonnage } })
  end

  def cooked_tonnage(semi_product_id: nil)
    scope = products
    scope = scope.filter_by_semi_product(semi_product_id) if semi_product_id
    scope.sum(:tonnage)
  end
end
