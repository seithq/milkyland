class DropScannedAtInBoxesAndPallets < ActiveRecord::Migration[8.1]
  def change
    remove_column :boxes, :scanned_at
    remove_column :pallets, :scanned_at
    add_column :boxes, :taken_out_at, :datetime
  end
end
