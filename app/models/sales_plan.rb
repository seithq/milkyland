class SalesPlan < ApplicationRecord
  belongs_to :region

  has_many :estimations, dependent: :destroy

  validates :month, presence: true, uniqueness: { scope: :region_id }

  scope :ordered, -> { order(month: :desc) }

  scope :filter_by_region, ->(region_id) { where(region_id: region_id) }

  def find_estimation(sales_channel_id, product_id)
    self.estimations.find_by sales_channel_id: sales_channel_id, product_id: product_id
  end
end
