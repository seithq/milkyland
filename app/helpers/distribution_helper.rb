module DistributionHelper
  def batch_distribution_path(batch)
    if batch.distribution.present? && !batch.distribution.new_record?
      production_plan_unit_batch_distribution_path(@batch.production_unit.plan, @batch.production_unit, @batch)
    else
      new_production_plan_unit_batch_distribution_path(@batch.production_unit.plan, @batch.production_unit, @batch)
    end
  end

  def distribution_color(distribution)
    case distribution.status
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
