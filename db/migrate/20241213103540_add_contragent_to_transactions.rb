class AddContragentToTransactions < ActiveRecord::Migration[8.1]
  def change
    add_reference :transactions, :contragent, polymorphic: true
  end
end
