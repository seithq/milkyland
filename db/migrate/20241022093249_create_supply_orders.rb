class CreateSupplyOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :supply_orders do |t|
      t.references :material_asset, null: false, foreign_key: true
      t.decimal :amount, precision: 20, scale: 2
      t.date :payment_date
      t.string :payment_status
      t.string :delivery_status

      t.timestamps
    end
  end
end
