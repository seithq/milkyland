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

  def planned_products_count
    result = []
    plan = batch.production_unit.plan
    plan.products.each do |product|
      plan.regions.each do |region|
        result << { product: product, region: region, count: calculate_count_for(plan, product, region) }
      end
    end
    result
  end

  def calculate_count_for(plan, product, region)
    orders_ids = plan.sales_points.filter_by_region(region).pluck(:order_id)
    plan.positions.filter_by_order(orders_ids).filter_by_product(product).sum(:count)
  end
end
