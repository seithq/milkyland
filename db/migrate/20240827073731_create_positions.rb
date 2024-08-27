class CreatePositions < ActiveRecord::Migration[8.0]
  def change
    create_table :positions do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :discounted_product, null: true, foreign_key: true
      t.integer :count
      t.decimal :base_price, precision: 20, scale: 3
      t.decimal :discounted_price, precision: 20, scale: 3
      t.decimal :total_sum, precision: 20, scale: 3

      t.timestamps
    end
  end
end
