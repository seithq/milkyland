class CreateContainers < ActiveRecord::Migration[8.0]
  def change
    create_table :containers do |t|
      t.references :packing_machine, null: false, foreign_key: true
      t.references :material_asset, null: false, foreign_key: true
      t.decimal :performance, precision: 20, scale: 2
      t.decimal :losses_percentage, precision: 20, scale: 2
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :containers, [ :packing_machine_id, :material_asset_id ], unique: true
  end
end
