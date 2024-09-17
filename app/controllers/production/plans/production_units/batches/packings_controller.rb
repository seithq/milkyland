module Production::Plans::ProductionUnits
  class Batches::PackingsController < ProductionController
    include PlanScoped, ProductionUnitScoped, BatchScoped

    before_action :set_journals
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
        redirect_on_update @packing
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @packing.update(packing_params)
        redirect_on_update @packing
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private
      def set_journals
        @journals = @batch.production_unit.group.journals
      end

      def set_packing
        @packing  = @batch.packing
      end

      def packing_params
        params.require(packing).permit(:status, :comment)
      end
  end
end
