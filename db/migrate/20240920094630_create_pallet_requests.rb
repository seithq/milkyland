class CreatePalletRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :pallet_requests do |t|
      t.references :generation, null: false, foreign_key: true
      t.integer :count

      t.timestamps
    end
  end
end
