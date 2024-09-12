class AddMeasurementToFields < ActiveRecord::Migration[8.0]
  def change
    add_reference :fields, :measurement, null: true, foreign_key: true
  end
end
