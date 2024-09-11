module Production
  class Plans::ProductionUnitsController < ProductionController
    include PlanScoped

    before_action :set_production_unit, only: %i[ show edit update ]

    def index
      @production_units = base_scope
    end

    def show
    end

    def edit
    end

    def update
      if @production_unit.update(production_unit_params)
        redirect_on_update production_plan_unit_path(@plan, @production_unit)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private
      def base_scope
        @plan.units.progressable
      end

      def set_production_unit
        @production_unit = base_scope.find(params[:id])
      end

      def production_unit_params
        params.require(:production_unit).permit(:group_id, :status, :comment)
      end
  end
end
