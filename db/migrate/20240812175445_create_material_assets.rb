class CreateMaterialAssets < ActiveRecord::Migration[8.0]
  def change
    create_table :material_assets do |t|
      t.string :name
      t.references :category, null: false, foreign_key: true
      t.references :supplier, null: false, foreign_key: true
      t.string :article
      t.decimal :entry_price, precision: 20, scale: 2
      t.string :packing
      t.references :measurement, null: false, foreign_key: true
      t.integer :delivery_time_in_days

      t.timestamps
    end
    add_index :material_assets, :article, unique: true
    add_index :material_assets, %i[ name supplier_id ], unique: true
  end
end
