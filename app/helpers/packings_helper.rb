module PackingsHelper
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
