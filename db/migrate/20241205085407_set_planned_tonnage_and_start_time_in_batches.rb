class SetPlannedTonnageAndStartTimeInBatches < ActiveRecord::Migration[8.1]
  def up
    Batch.find_each do |batch|
      batch.update(planned_tonnage: batch.produced_tonnage, planned_start_time: batch.created_at)
    end
  end

  def down
  end
end
