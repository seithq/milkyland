module Production::Plans
  class ProductionUnits::BatchesController < ProductionController
    include PlanScoped, ProductionUnitScoped

    before_action :set_batch, only: %i[ show edit update ]

    def index
      @batches = base_scope
    end

    def show
    end

    def new
      @batch = base_scope.new
    end

    def edit
    end

    def create
      @batch = base_scope.new(batch_params)

      if @batch.save
        redirect_on_create production_plan_unit_path(@plan, @production_unit)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @batch.update(batch_params)
        redirect_on_update production_plan_unit_batch_path(@plan, @production_unit, @batch)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private
      def base_scope
        @production_unit.batches.progressable
      end

      def set_batch
        @batch = base_scope.find(params[:id])
      end

      def batch_params
        params.require(:batch).permit(:machiner_id, :tester_id, :operator_id, :loader_id, :status, :comment)
      end
  end
end
