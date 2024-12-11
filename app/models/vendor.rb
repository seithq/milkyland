class Vendor < ApplicationRecord
  include Deactivatable

  belongs_to :material_asset
  belongs_to :supplier

  has_many :supply_orders, dependent: :nullify

  validates_uniqueness_of :supplier_id, scope: :material_asset_id
  validates :entry_price, presence: true, numericality: { greater_than: 0.0 }

  def display_label
    supplier.name
  end
end
