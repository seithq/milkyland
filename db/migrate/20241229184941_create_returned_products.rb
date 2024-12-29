class CreateReturnedProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :returned_products do |t|
      t.references :return, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :count

      t.timestamps
    end
  end
end
