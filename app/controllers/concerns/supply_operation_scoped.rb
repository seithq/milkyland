module SupplyOperationScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_waybill
  end

  private
    def set_waybill
      @waybill = Waybill.find(params[:supply_operation_id])
    end
end
