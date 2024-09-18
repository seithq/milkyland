module OperationsHelper
  def step_color(batch, operation)
    fallback = " border-2 border-gray-600 focus-within:ring-2 focus-within:ring-indigo-500 focus-within:ring-offset-2 hover:border-indigo-500"
    return fallback unless operation.has_step? batch

    step = operation.batch_steps(batch).first
    case step.status
    when "in_progress"
      " border-2 border-blue-600"
    when "completed"
      " border-2 border-green-600"
    when "cancelled"
      " border-2 border-red-600"
    else
      fallback
    end
  end
end
