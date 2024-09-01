class AddTonneRatioToMeasurements < ActiveRecord::Migration[8.0]
  def change
    add_column :measurements, :tonne_ratio, :decimal, precision: 20, scale: 3
  end
end
