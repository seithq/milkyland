class AddReturnedProductToBoxes < ActiveRecord::Migration[8.1]
  def change
    add_reference :boxes, :returned_product, null: true, foreign_key: true
  end
end
