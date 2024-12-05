module Production::Plans
  class ProductionUnits::BatchesController < ProductionController
    include PlanScoped, ProductionUnitScoped

    before_action :set_batch, only: %i[ show edit update info ]

    def index
      @batches = base_scope
    end

    def show
    end

    def info
    end

    def new
      @batch = base_scope.new
    end

    def edit
    end

    def create
      @batch = base_scope.new(batch_params)

      if @batch.save
        redirect_on_create production_plan_unit_url(@plan, @production_unit)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @batch.update(batch_params)
        post_update_hook @batch
        redirect_on_update production_plan_unit_batch_url(@plan, @production_unit, @batch)
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
        @journals = @batch.journals
      end

      def batch_params
        params.require(:batch).permit(:machiner_id, :tester_id, :operator_id, :loader_id, :storage_id, :status, :comment, :planned_tonnage, :planned_start_time, :actual_start_time)
      end

      def post_update_hook(batch)
        return unless batch.step_completed?

        WriteOffMaterialAssetsJob.perform_later batch.id
        ArriveSemiProductsJob.perform_later batch.id
      end
  end
end
