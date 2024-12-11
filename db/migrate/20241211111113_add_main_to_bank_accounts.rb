class AddMainToBankAccounts < ActiveRecord::Migration[8.1]
  def change
    add_column :bank_accounts, :main, :boolean, default: false
  end
end
