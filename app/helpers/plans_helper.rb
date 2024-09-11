module PlansHelper
  def plan_status(plan)
    tag.span class: plan_color(plan) do
      Plan.enum_to_s(:statuses, plan.status)
    end
  end

  def should_cancel?
    params[:cancel].present? && params[:cancel] == "true"
  end

  def should_finish?
    params[:finish].present? && params[:finish] == "true"
  end

  def batch_url(batch)
    if batch.new_record?
      production_plan_unit_batches_path(@plan, @production_unit)
    else
      production_plan_unit_batch_path(@plan, @production_unit, batch)
    end
  end

  private
    def plan_color(plan)
      base = "px-2 py-1 rounded-lg text-base font-semibold leading-7 mr-2"
      case plan.status
      when "ready_to_production"
        base + " bg-orange-300 text-gray-900"
      when "in_production"
        base + " bg-blue-600 text-white"
      when "produced"
        base + " bg-green-600 text-white"
      when "cancelled"
        base + " bg-red-600 text-white"
      else
        base
      end
    end
end
