class CreateSinglePackagings < ActiveRecord::Migration[8.1]
  def change
    create_table :single_packagings do |t|
      t.references :product, null: false, foreign_key: true
      t.references :material_asset, null: false, foreign_key: true
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :single_packagings, %i[ product_id material_asset_id ], unique: true
  end
end
