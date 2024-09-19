module Production::Plans::ProductionUnits
  class Batches::StepsController < ProductionController
    include PlanScoped, ProductionUnitScoped, BatchScoped

    before_action :set_step, only: %i[ edit update ]

    def edit
    end

    def create
      @step = base_scope.new(step_params)
      @step.build_fields
      @step.save!

      redirect_on_create production_plan_unit_batch_journal_url(@plan, @production_unit, @batch, @step.operation.journal), text: t("actions.operation_started")
    end

    def update
      if @step.update(step_params)
        redirect_on_update production_plan_unit_batch_journal_url(@plan, @production_unit, @batch, @step.operation.journal)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private
      def base_scope
        @batch.steps
      end

      def set_step
        @step = base_scope.find(params[:id])
      end

      def step_params
        params.require(:step).permit(:operation_id, :status, :comment, metrics_attributes: %i[ id value ])
      end
  end
end
