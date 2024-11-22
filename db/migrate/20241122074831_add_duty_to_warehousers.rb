class AddDutyToWarehousers < ActiveRecord::Migration[8.0]
  def change
    add_column :warehousers, :duty, :string
    add_reference :warehousers, :replaceable, null: true, foreign_key: { to_table: :users }
  end
end
