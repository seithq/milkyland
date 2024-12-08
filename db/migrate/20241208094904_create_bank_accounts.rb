class CreateBankAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :bank_accounts do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name
      t.string :number

      t.timestamps
    end
    add_index :bank_accounts, [ :company_id, :name ], unique: true
  end
end
