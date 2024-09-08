class AddChainOrderToFields < ActiveRecord::Migration[8.0]
  def change
    add_column :fields, :chain_order, :integer, default: 0
  end
end
