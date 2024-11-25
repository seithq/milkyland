module Production::Plans::ProductionUnits
  class Batches::CookingsController < ProductionController
    include PlanScoped, ProductionUnitScoped, BatchScoped

    before_action :set_journals
    before_action :ensure_has_no_cooking, only: :new
    before_action :ensure_has_cooking, :set_cooking, only: %i[ show edit update ]

    def show
    end

    def new
      @cooking = @batch.build_cooking
    end

    def edit
    end

    def create
      @cooking = @batch.build_cooking(cooking_params)
      @cooking.build_semi_products

      if @cooking.save
        redirect_on_update production_plan_unit_batch_cooking_url(@plan, @production_unit, @batch)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @cooking.update(cooking_params)
        redirect_on_update production_plan_unit_batch_cooking_url(@plan, @production_unit, @batch)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private
      def set_journals
        @journals = @batch.journals
      end

      def set_cooking
        @cooking = @batch.cooking
      end

      def cooking_params
        params.expect(cooking: %i[ status comment])
      end

      def ensure_has_no_cooking
        if @batch.cooking.present?
          redirect_to production_plan_unit_batch_cooking_url(@plan, @production_unit, @batch)
        end
      end

      def ensure_has_cooking
        unless @batch.cooking.present?
          redirect_to new_production_plan_unit_batch_cooking_url(@plan, @production_unit, @batch)
        end
      end
  end
end
