class Distribution < ApplicationRecord
  include Progressable

  belongs_to :batch

  has_many :products, class_name: "DistributedProduct", foreign_key: "distribution_id", dependent: :destroy
  accepts_nested_attributes_for :products

  def build_products
    plan   = batch.production_unit.plan
    params = []

    batch.packing.products.each do |packaged|
      plan.regions.each do |region|
        params << { distribution: self,
                    packaged_product: packaged,
                    region: region,
                    production_date: plan.production_date,
                    count: 0
        }
      end
    end

    products.build(params)
  end

  def distributed_count(product_id: nil)
    scope = products
    scope = scope.filter_by_product(product_id) if product_id
    scope.sum(:count)
  end

  def equal_to_packing?
    available_products.each do |product|
      if self.distributed_count(product_id: product.id) != self.batch.packing.packed_count(product_id: product.id)
        return false
      end
    end
    true
  end

  def available_products
    Product.where(id: self.products.joins(:packaged_product).pluck(:product_id))
  end
end
