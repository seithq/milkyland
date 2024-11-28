module ShipmentScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_shipment
  end

  private
    def set_shipment
      @shipment = Shipment.find(params[:shipment_id])
    end
end
