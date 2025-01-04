class Estimation < ApplicationRecord
  belongs_to :sales_plan
  belongs_to :sales_channel
  belongs_to :product

  validates :planned_count, presence: true, comparison: { greater_than_or_equal_to: 0 }

  scope :filter_by_sales_channel, ->(sales_channel_id) { where(sales_channel_id: sales_channel_id) }
  scope :filter_by_product, ->(product_id) { where(product_id: product_id) }
  scope :filter_by_month, ->(start_date, end_date) { joins(:sales_plan).where("sales_plans.month >= ? AND sales_plans.month <= ?", start_date, end_date) }
end
