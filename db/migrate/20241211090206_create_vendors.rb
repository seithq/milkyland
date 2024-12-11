class CreateVendors < ActiveRecord::Migration[8.1]
  def change
    create_table :vendors do |t|
      t.references :material_asset, null: false, foreign_key: true
      t.references :supplier, null: false, foreign_key: true
      t.decimal :entry_price, precision: 20, scale: 2
      t.integer :delivery_time_in_days
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
