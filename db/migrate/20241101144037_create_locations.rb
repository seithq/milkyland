class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.references :storable, polymorphic: true, null: false
      t.references :positionable, polymorphic: true, null: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
