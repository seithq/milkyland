class AddChainOrderToOperations < ActiveRecord::Migration[8.0]
  def change
    add_column :operations, :chain_order, :integer, default: 0
  end
end
