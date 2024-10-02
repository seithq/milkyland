module Production::Plans::ProductionUnits
  class Batches::DistributionsController < ProductionController
    include PlanScoped, ProductionUnitScoped, BatchScoped

    before_action :set_journals
    before_action :ensure_has_no_distribution, only: :new
    before_action :ensure_has_distribution, :set_distribution, only: %i[ show edit update ]

    def show
    end

    def new
      @distribution = @batch.build_distribution
    end

    def edit
    end

    def create
      @distribution = @batch.build_distribution(distribution_params)
      @distribution.build_products

      if @distribution.save
        redirect_on_update production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @distribution.update(distribution_params)
        redirect_on_update production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private
    def set_journals
      @journals = @batch.journals
    end

    def set_distribution
      @distribution = @batch.distribution
    end

    def distribution_params
      params.require(:distribution).permit(:status, :comment)
    end

    def ensure_has_no_distribution
      if @batch.distribution.present?
        redirect_to production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
      end
    end

    def ensure_has_distribution
      unless @batch.distribution.present?
        redirect_to new_production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
      end
    end
  end
end
