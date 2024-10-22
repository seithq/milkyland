module SupplyHelper
  def supply_operation_url_for(waybill)
    waybill.new_record? ? supply_operations_url : supply_operation_url(waybill)
  end
end
