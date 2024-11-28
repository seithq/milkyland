class CreateShipments < ActiveRecord::Migration[8.1]
  def change
    create_table :shipments do |t|
      t.references :plan, null: true, foreign_key: true
      t.references :region, null: false, foreign_key: true
      t.references :client, null: true, foreign_key: true
      t.date :shipping_date
      t.string :kind
      t.string :status
      t.datetime :routes_changed_at

      t.timestamps
    end
  end
end
