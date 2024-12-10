class Finance::CashFlowRowTotalComponent < ApplicationComponent
  option :sum, required: true

  def text_color
    return "text-green-600" if sum > 0
    return "text-red-600" if sum < 0

    "text-gray-700"
  end
end
