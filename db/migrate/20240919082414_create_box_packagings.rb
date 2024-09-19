class CreateBoxPackagings < ActiveRecord::Migration[8.0]
  def change
    create_table :box_packagings do |t|
      t.references :product, null: false, foreign_key: true
      t.references :material_asset, null: false, foreign_key: true
      t.integer :count
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :box_packagings, %i[ product_id material_asset_id ], unique: true
  end
end
