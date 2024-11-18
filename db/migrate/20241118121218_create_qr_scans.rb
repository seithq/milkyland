class CreateQrScans < ActiveRecord::Migration[8.0]
  def change
    create_table :qr_scans do |t|
      t.references :waybill, null: false, foreign_key: true
      t.string :code
      t.references :sourceable, polymorphic: true, null: false
      t.references :box, null: false, foreign_key: true
      t.integer :capacity_before
      t.integer :capacity_after
      t.datetime :scanned_at

      t.timestamps
    end
  end
end
