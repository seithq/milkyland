class CreateTrackingOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :tracking_orders do |t|
      t.references :route_sheet, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
