class Mobile::StatusBadgeComponent < ApplicationComponent
  option :waybill

  private
    def badge_color
      case waybill.status
      when "approved"
        "bg-green-500"
      when "pending"
        "bg-yellow-500"
      else
        "bg-gray-900/80"
      end
    end
end
