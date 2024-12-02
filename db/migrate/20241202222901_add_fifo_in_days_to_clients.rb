class AddFifoInDaysToClients < ActiveRecord::Migration[8.1]
  def change
    add_column :clients, :fifo_in_days, :integer, default: 0
  end
end
