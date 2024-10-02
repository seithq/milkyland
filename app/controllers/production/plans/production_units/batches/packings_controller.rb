module Production::Plans::ProductionUnits
  class Batches::PackingsController < ProductionController
    include PlanScoped, ProductionUnitScoped, BatchScoped

    before_action :set_journals
    before_action :ensure_has_no_packing, only: :new
    before_action :ensure_has_packing, :set_packing, only: %i[ show edit update ]

    def show
    end

    def new
      @packing = @batch.build_packing
    end

    def edit
    end

    def create
      @packing = @batch.build_packing(packing_params)
      @packing.build_products

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
        @journals = @batch.journals
      end

      def set_packing
        @packing = @batch.packing
      end

      def packing_params
        params.require(:packing).permit(:status, :comment)
      end

      def ensure_has_no_packing
        if @batch.packing.present?
          redirect_to production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
        end
      end

      def ensure_has_packing
        unless @batch.packing.present?
          redirect_to new_production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
        end
      end
  end
end
