class CreateIngredients < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredients do |t|
      t.references :group, null: false, foreign_key: true
      t.references :material_asset, null: false, foreign_key: true
      t.decimal :ratio, precision: 20, scale: 3
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
