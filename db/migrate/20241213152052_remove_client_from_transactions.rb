class RemoveClientFromTransactions < ActiveRecord::Migration[8.1]
  def change
    remove_reference :transactions, :client
  end
end
