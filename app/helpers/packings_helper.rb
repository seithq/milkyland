module PackingsHelper
  def batch_packing_path(batch)
    if batch.packing.present? && !batch.packing.new_record?
      production_plan_unit_batch_packing_path(@batch.production_unit.plan, @batch.production_unit, @batch)
    else
      new_production_plan_unit_batch_packing_path(@batch.production_unit.plan, @batch.production_unit, @batch)
    end
  end

  def packing_color(packing)
    case packing.status
    when "in_progress"
      " border-2 border-blue-600"
    when "completed"
      " border-2 border-green-600"
    when "cancelled"
      " border-2 border-red-600"
    else
      ""
    end
  end
end
