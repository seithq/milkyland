module Production::Plans::ProductionUnits::Batches
  class Cookings::CookedSemiProductsController < ProductionController
    include PlanScoped, ProductionUnitScoped, BatchScoped, CookingScoped

    before_action :set_cooked_semi_product, only: %i[ edit update ]

    def index
      @cooked_semi_products = get_scope params
    end

    def edit
    end

    def update
      if @cooked_semi_product.update(cooked_semi_product_params)
        redirect_on_update production_plan_unit_batch_cooking_url(@plan, @production_unit, @batch)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private
      def base_scope
        @cooking.semi_products
      end

      def set_cooked_semi_product
        @cooked_semi_product = base_scope.find(params.expect(:id))
      end

      def cooked_semi_product_params
        params.expect(cooked_semi_product: %i[ semi_product_id tonnage])
      end
  end
end
