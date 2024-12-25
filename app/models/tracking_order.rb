class TrackingOrder < ApplicationRecord
  belongs_to :route_sheet
  belongs_to :order

  validates_uniqueness_of :order_id, scope: :route_sheet_id

  after_save    :calculate_tracking_products
  after_destroy :calculate_tracking_products

  private
    def calculate_tracking_products
      transaction do
        route_sheet.tracking_products.destroy_all
        route_sheet.positions.group(:product_id).sum(:count).each do |product_id, count|
          route_sheet.tracking_products.create! product_id: product_id, count: count, unrestricted_count: 0
        end
      end
    end
end
