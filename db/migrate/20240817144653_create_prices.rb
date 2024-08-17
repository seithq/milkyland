class CreatePrices < ActiveRecord::Migration[8.0]
  def change
    create_table :prices do |t|
      t.references :product, null: false, foreign_key: true
      t.references :sales_channel, null: false, foreign_key: true
      t.decimal :value, precision: 20, scale: 2
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :prices, [ :product_id, :sales_channel_id ], unique: true
  end
end
