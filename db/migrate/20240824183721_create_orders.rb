class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :sales_channel, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.references :sales_point, null: false, foreign_key: true
      t.integer :kind
      t.string :status
      t.date :preferred_date

      t.timestamps
    end
  end
end
