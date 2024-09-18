module UnitsHelper
  def unit_color(unit)
    case unit.status
    when "in_progress"
      " border-2 border-blue-600"
    when "completed"
      " border-2 border-green-600"
    when "cancelled"
      " border-2 border-red-600"
    else
      " border-2 border-gray-600 focus-within:ring-2 focus-within:ring-indigo-500 focus-within:ring-offset-2 hover:border-indigo-500"
    end
  end
end
