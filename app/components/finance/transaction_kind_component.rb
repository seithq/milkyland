class Finance::TransactionKindComponent < ApplicationComponent
  option :transaction

  private
    def badge_color
      case transaction.kind
      when "income"
        "bg-green-50 text-green-700 ring-green-600/20"
      when "expense"
        "bg-red-50 text-red-700 ring-red-600/10"
      else
        "bg-gray-50 text-gray-600 ring-gray-500/10"
      end
    end
end
