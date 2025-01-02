class Estimation < ApplicationRecord
  belongs_to :sales_plan
  belongs_to :sales_channel
  belongs_to :product

  validates :planned_count, presence: true, comparison: { greater_than_or_equal_to: 0 }
end
