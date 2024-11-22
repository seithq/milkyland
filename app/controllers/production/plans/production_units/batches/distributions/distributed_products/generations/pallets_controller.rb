module Production::Plans::ProductionUnits::Batches::Distributions::DistributedProducts
  class Generations::PalletsController < ProductionController
    include PlanScoped, ProductionUnitScoped, BatchScoped, DistributionScoped, DistributedProductScoped, GenerationScoped

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

    def download
      images = @generation.pallets.map { |pallet| [ pallet.qr_image, pallet.qr_image.filename, modification_time: pallet.created_at ] }
      zipline images, @generation.zip_name
    end

    private
      def pallet_request_params
        params.require(:pallet_request).permit(:count)
      end
  end
end
