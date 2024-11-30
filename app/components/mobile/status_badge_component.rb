class Mobile::StatusBadgeComponent < ApplicationComponent
  option :record

  private
    def badge_color
      case record.status
      when "approved"
        "bg-green-500"
      when "pending"
        "bg-yellow-500"
      else
        "bg-gray-900/80"
      end
    end
end
