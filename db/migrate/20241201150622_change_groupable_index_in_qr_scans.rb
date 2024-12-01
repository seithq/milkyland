class ChangeGroupableIndexInQrScans < ActiveRecord::Migration[8.1]
  def change
    remove_index :qr_scans, :groupable_id
    remove_foreign_key :qr_scans, :groupable_id, to_table: :waybills
    add_index :qr_scans, %i[ groupable_type groupable_id ], name: "index_qr_scans_on_groupable"
  end
end
