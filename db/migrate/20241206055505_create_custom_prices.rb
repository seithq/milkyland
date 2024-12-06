class CreateCustomPrices < ActiveRecord::Migration[8.1]
  def change
    create_table :custom_prices do |t|
      t.references :product, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.decimal :value, precision: 20, scale: 2
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :custom_prices, [ :product_id, :client_id ], unique: true
  end
end
