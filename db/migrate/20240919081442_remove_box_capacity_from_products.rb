class RemoveBoxCapacityFromProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :box_capacity
  end
end
