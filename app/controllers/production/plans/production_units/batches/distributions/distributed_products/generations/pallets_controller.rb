module Production::Plans::ProductionUnits::Batches::Distributions::DistributedProducts
  class Generations::PalletsController < ProductionController
    include PlanScoped, ProductionUnitScoped, BatchScoped, DistributionScoped, DistributedProductScoped, GenerationScoped, Zipable

    def index
      @pagy, @pallets = pagy @generation.pallets
    end

    def new
      @pallet_request = @generation.pallet_requests.new
    end

    def create
      @pallet_request = @generation.pallet_requests.new(pallet_request_params)

      if @pallet_request.save
        redirect_on_create production_plan_unit_batch_distribution_distributed_product_generation_pallets_url(@plan, @production_unit, @batch, @distributed_product)
      else
        render :new, status: :unprocessable_entity
      end
    end

    private
      def pallet_request_params
        params.require(:pallet_request).permit(:count)
      end

      def init_download
        @generation.create_pallets_download kind: :pallets, status: :processing
      end

      def zip_class
        "Pallet"
      end

      def zip_scope
        @generation.pallets
      end

      def zip_name
        @generation.zip_name("P")
      end

      def post_download_url
        production_plan_unit_batch_distribution_distributed_product_generation_url(@plan, @production_unit, @batch, @distributed_product)
      end
  end
end
