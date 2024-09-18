module Production::Plans::ProductionUnits
  class Batches::DistributionsController < ProductionController
    include PlanScoped, ProductionUnitScoped, BatchScoped

    before_action :set_journals
    before_action :avoid_override, only: :new
    before_action :set_distribution, only: %i[ show edit update ]

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
        puts "="*80
        puts @distribution.errors.full_messages
        puts "="*80
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @distribution.update(distribution_params)
        if @distribution.completed?
          # Generate QR images
        end

        redirect_on_update production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private
    def set_journals
      @journals = @batch.production_unit.group.journals
    end

    def set_distribution
      @distribution = @batch.distribution
    end

    def distribution_params
      params.require(:distribution).permit(:status, :comment)
    end

    def avoid_override
      if Distribution.exists?(batch_id: @batch.id)
        redirect_to redirect_on_update production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
      end
    end
  end
end
