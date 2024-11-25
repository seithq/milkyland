class CreateSemiProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :semi_products do |t|
      t.references :group, null: false, foreign_key: true
      t.string :name
      t.references :measurement, null: false, foreign_key: true
      t.integer :expiration_in_days
      t.string :storage_conditions

      t.timestamps
    end
    add_index :semi_products, :name, unique: true
  end
end
