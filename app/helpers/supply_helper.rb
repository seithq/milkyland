module SupplyHelper
  def supply_operation_url_for(waybill)
    waybill.new_record? ? supply_operations_url : supply_operation_url(waybill)
  end

  def supply_leftover_url_for(waybill, leftover)
    leftover.new_record? ? supply_operation_leftovers_url(waybill) : supply_operation_leftover_url(waybill, leftover)
  end
end
