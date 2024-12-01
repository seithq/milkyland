class AddRouteSheetToWaybills < ActiveRecord::Migration[8.1]
  def change
    add_reference :waybills, :route_sheet, null: true, foreign_key: true
    add_column :waybills, :collectable, :boolean, default: false
  end
end
