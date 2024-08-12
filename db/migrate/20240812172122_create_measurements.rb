class CreateMeasurements < ActiveRecord::Migration[8.0]
  def change
    create_table :measurements do |t|
      t.string :name
      t.string :unit

      t.timestamps
    end
    add_index :measurements, :unit, unique: true
  end
end
