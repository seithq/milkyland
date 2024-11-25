class CreateSemiIngredients < ActiveRecord::Migration[8.1]
  def change
    create_table :semi_ingredients do |t|
      t.references :group, null: false, foreign_key: true
      t.references :semi_product, null: false, foreign_key: true
      t.decimal :ratio, precision: 20, scale: 3
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
