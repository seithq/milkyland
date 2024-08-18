class CreateSalesPoints < ActiveRecord::Migration[8.0]
  def change
    create_table :sales_points do |t|
      t.references :client, null: false, foreign_key: true
      t.string :name
      t.text :address
      t.string :phone_number
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :sales_points, [ :client_id, :name ], unique: true
  end
end
