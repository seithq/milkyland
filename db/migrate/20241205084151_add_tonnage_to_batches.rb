class AddTonnageToBatches < ActiveRecord::Migration[8.1]
  def change
    add_column :batches, :planned_tonnage, :decimal, precision: 10, scale: 2
    add_column :batches, :planned_start_time, :datetime
    add_column :batches, :actual_start_time, :datetime
  end
end
