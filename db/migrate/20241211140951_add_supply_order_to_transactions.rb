class AddSupplyOrderToTransactions < ActiveRecord::Migration[8.1]
  def change
    add_reference :transactions, :supply_order, null: true, foreign_key: true
  end
end
