module Production::Plans::ProductionUnits::Batches
  class Packings::PackagedProductsController < ProductionController
    include PlanScoped, ProductionUnitScoped, BatchScoped, PackingScoped

    before_action :set_packaged_product, only: %i[ edit update ]

    def index
      @packaged_products = get_scope params
    end

    def edit
    end

    def update
      if @packaged_product.update(packaged_product_params)
        redirect_on_update production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private
      def base_scope
        @packing.products
      end

      def set_packaged_product
        @packaged_product = base_scope.find(params.expect(:id))
      end

      def packaged_product_params
        params.require(:packaged_product).permit(:start_time, :end_time, :count, :comment)
      end
  end
end
