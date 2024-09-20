class CreatePallets < ActiveRecord::Migration[8.0]
  def change
    create_table :pallets do |t|
      t.string :code
      t.references :pallet_request, null: true, foreign_key: true
      t.datetime :scanned_at

      t.timestamps
    end
    add_index :pallets, :code, unique: true
  end
end
