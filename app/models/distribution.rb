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
                    count: plan.product_region_remaining_sum(self.batch, region, packaged.product)
        }
      end
    end

    products.build(params)
  end
end
