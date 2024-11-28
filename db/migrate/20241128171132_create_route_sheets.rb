class CreateRouteSheets < ActiveRecord::Migration[8.1]
  def change
    create_table :route_sheets do |t|
      t.references :shipment, null: false, foreign_key: true
      t.string :vehicle_plate_number
      t.string :driver_name
      t.string :driver_phone_number
      t.string :status
      t.text :comment
      t.boolean :generated

      t.timestamps
    end
  end
end
