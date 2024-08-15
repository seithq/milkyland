class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.references :group, null: false, foreign_key: true
      t.string :name
      t.string :article
      t.decimal :packing, precision: 20, scale: 2
      t.references :measurement, null: false, foreign_key: true
      t.integer :expiration_in_days
      t.string :storage_conditions
      t.integer :box_capacity
      t.decimal :fat_fraction, precision: 20, scale: 2
      t.references :material_asset, null: false, foreign_key: true

      t.timestamps
    end
    add_index :products, :name, unique: true
    add_index :products, :article, unique: true
  end
end
