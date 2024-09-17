class CreatePackagedProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :packaged_products do |t|
      t.references :packing, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.time :start_time
      t.time :end_time
      t.integer :count

      t.timestamps
    end
    add_index :packaged_products, [ :packing_id, :product_id ], unique: true
  end
end
