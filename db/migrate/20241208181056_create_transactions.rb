class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.references :bank_account, null: false, foreign_key: true
      t.references :article, null: false, foreign_key: true
      t.references :client, null: true, foreign_key: true
      t.references :material_asset, null: true, foreign_key: true
      t.references :linked_transaction, null: true, foreign_key: { to_table: :transactions }
      t.string :kind
      t.decimal :amount
      t.string :status
      t.text :comment
      t.date :planned_date
      t.date :execution_date

      t.timestamps
    end
  end
end
