class AddOrderNumberToActivityType < ActiveRecord::Migration[8.1]
  def change
    add_column :activity_types, :order_number, :integer, default: 0
  end
end
