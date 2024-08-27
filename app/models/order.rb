class Order < ApplicationRecord
  belongs_to :sales_channel
  belongs_to :client
  belongs_to :sales_point

  has_many :positions, dependent: :destroy

  enum :kind, %i[ planned unscheduled ], default: :planned
  enum :status, %w[ in_planning in_production in_delivery completed cancelled ].index_by(&:itself), default: :in_planning

  scope :filter_by_status, ->(status) { where status: status }
  scope :filter_by_id_or_client_or_sales_point, ->(query) { joins(:client).joins(:sales_point).where("LOWER(orders.id::text) LIKE ? OR LOWER(clients.name) LIKE ? OR LOWER(sales_points.name) LIKE ?", like(query), like(query), like(query)) }

  scope :active, ->() { where.not(status: %i[ completed cancelled ]) }

  def cancel
    update! status: :cancelled
  end

  def sum
    positions.sum(:total_sum)
  end

  def can_edit?
    in_planning?
  end

  def can_be_canceled?
    in_planning?
  end

  def eligible_promotions_for(product)
    promotions = Promotion.running.filter_by_eligible client_id: self.client_id, product_id: product.id
    promotions.sort_by { |promo| promo.calculate_discount_for product.price(by: self.sales_channel_id) }
  end
end
