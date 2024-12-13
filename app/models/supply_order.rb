class SupplyOrder < ApplicationRecord
  belongs_to :material_asset
  belongs_to :vendor, optional: true

  validates :amount, presence: true, numericality: { greater_than: 0.0 }
  validates :payment_date, presence: true, comparison: { greater_than_or_equal_to: Time.zone.today }

  enum :payment_status, %w[ pending paid ].index_by(&:itself), default: :pending
  enum :delivery_status, %w[ delivering delivered ].index_by(&:itself), default: :delivering

  scope :filter_by_payment_status,  ->(payment_status)  { where(payment_status: payment_status) }
  scope :filter_by_delivery_status, ->(delivery_status) { where(delivery_status: delivery_status) }

  def total_amount
    return 0.0 unless vendor.present?

    amount.to_d * vendor.entry_price.to_d
  end
end
