class AddChainOrderToJournals < ActiveRecord::Migration[8.0]
  def change
    add_column :journals, :chain_order, :integer, default: 0
  end
end
