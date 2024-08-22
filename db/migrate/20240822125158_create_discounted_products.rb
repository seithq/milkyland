class CreateDiscountedProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :discounted_products do |t|
      t.references :promotion, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :discounted_products, [ :promotion_id, :product_id ], unique: true
  end
end
