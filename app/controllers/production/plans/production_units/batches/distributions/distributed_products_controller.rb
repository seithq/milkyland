module Production::Plans::ProductionUnits::Batches
  class Distributions::DistributedProductsController < ProductionController
    include PlanScoped, ProductionUnitScoped, BatchScoped, DistributionScoped

    before_action :set_distributed_product, only: %i[ edit update ]

    def index
      @distributed_products = get_scope params
    end

    def edit
    end

    def update
      if @distributed_product.update(distributed_product_params)
        redirect_on_update production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private
      def base_scope
        @distribution.products
      end

      def set_distributed_product
        @distributed_product = base_scope.find(params.expect(:id))
      end

      def distributed_product_params
        params.require(:distributed_product).permit(:production_date, :count)
      end
  end
end
