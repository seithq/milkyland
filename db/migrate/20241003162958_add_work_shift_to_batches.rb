class AddWorkShiftToBatches < ActiveRecord::Migration[8.0]
  def change
    add_column :batches, :work_shift, :string, default: "daily"
  end
end
