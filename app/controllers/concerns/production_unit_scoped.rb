module ProductionUnitScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_production_unit
  end

  private
    def set_production_unit
      @production_unit = ProductionUnit.find(params[:unit_id])
    end
end
