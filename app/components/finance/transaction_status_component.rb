class Finance::TransactionStatusComponent < ApplicationComponent
  option :transaction

  private
    def badge_color
      case transaction.status
      when "pending"
        "bg-yellow-50 text-yellow-800 ring-yellow-600/20"
      when "confirmed"
        "bg-blue-50 text-blue-700 ring-blue-700/10"
      when "completed"
        "bg-green-50 text-green-700 ring-green-600/20"
      when "cancelled"
        "bg-red-50 text-red-700 ring-red-600/10"
      else
        "bg-gray-50 text-gray-600 ring-gray-500/10"
      end
    end
end
