class CreateMachineries < ActiveRecord::Migration[8.1]
  def change
    create_table :machineries do |t|
      t.references :packaged_product, null: false, foreign_key: true
      t.references :packing_machine, null: false, foreign_key: true
      t.references :material_asset, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.integer :count

      t.timestamps
    end
    add_index :machineries, [ :packaged_product_id, :packing_machine_id, :material_asset_id ], unique: true
  end
end
