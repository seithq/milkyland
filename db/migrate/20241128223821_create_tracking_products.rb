class CreateTrackingProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :tracking_products do |t|
      t.references :route_sheet, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :count
      t.integer :unrestricted_count

      t.timestamps
    end
  end
end
