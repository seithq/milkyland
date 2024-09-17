module Production::Plans::ProductionUnits
  class Batches::PackingsController < ProductionController
    include PlanScoped, ProductionUnitScoped, BatchScoped

    before_action :set_journals
    before_action :avoid_override, only: :new
    before_action :set_packing, only: %i[ show edit update ]

    def show
    end

    def new
      @packing = @batch.build_packing
    end

    def edit
    end

    def create
      @packing = @batch.build_packing(packing_params)
      @packing.build_commodities

      if @packing.save
        redirect_on_update production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @packing.update(packing_params)
        redirect_on_update production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private
      def set_journals
        @journals = @batch.production_unit.group.journals
      end

      def set_packing
        @packing = @batch.packing
      end

      def packing_params
        params.require(:packing).permit(:status, :comment)
      end

      def avoid_override
        if Packing.exists?(batch_id: @batch.id)
          redirect_to production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
        end
      end
  end
end
