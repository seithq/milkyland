module OperationsHelper
  def step_color(batch, operation)
    return "" unless operation.has_step? batch

    step = operation.batch_steps(batch).first
    case step.status
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
