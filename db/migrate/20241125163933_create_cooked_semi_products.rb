class CreateCookedSemiProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :cooked_semi_products do |t|
      t.references :cooking, null: false, foreign_key: true
      t.references :semi_product, null: false, foreign_key: true
      t.decimal :tonnage

      t.timestamps
    end
  end
end
