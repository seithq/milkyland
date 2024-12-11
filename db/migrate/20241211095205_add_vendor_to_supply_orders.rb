class AddVendorToSupplyOrders < ActiveRecord::Migration[8.1]
  def change
    add_reference :supply_orders, :vendor, null: true, foreign_key: true
  end
end
