class ChangeWaybillReferenceInQrScans < ActiveRecord::Migration[8.1]
  def change
    rename_column :qr_scans, :waybill_id, :groupable_id
    add_column :qr_scans, :groupable_type, :string, default: "Waybill"
  end
end
