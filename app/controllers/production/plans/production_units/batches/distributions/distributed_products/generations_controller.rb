module Production::Plans::ProductionUnits::Batches::Distributions
  class DistributedProducts::GenerationsController < ProductionController
    include PlanScoped, ProductionUnitScoped, BatchScoped, DistributionScoped, DistributedProductScoped

    before_action :ensure_has_no_generation, only: :new
    before_action :ensure_has_generation, :set_generation, only: %i[ download show ]

    def download
      images = @generation.boxes.map { |box| [ box.qr_image, box.qr_image.filename, modification_time: box.created_at ] }
      zipline images, @generation.zip_name
    end

    def show
    end

    def new
      @generation = @distributed_product.build_generation
    end

    def create
      @generation = @distributed_product.build_generation(generation_params)

      if @generation.save
        redirect_on_create production_plan_unit_batch_distribution_distributed_product_generation_url(@plan, @production_unit, @batch, @distributed_product)
      else
        render :new, status: :unprocessable_entity
      end
    end

    private
      def set_generation
        @generation = @distributed_product.generation
      end

      def ensure_has_no_generation
        if @distributed_product.generation.present?
          redirect_to production_plan_unit_batch_distribution_distributed_product_generation_url(@plan, @production_unit, @batch, @distributed_product)
        end
      end

      def ensure_has_generation
        unless @distributed_product.generation.present?
          redirect_to new_production_plan_unit_batch_distribution_distributed_product_generation_url(@plan, @production_unit, @batch, @distributed_product)
        end
      end

      def generation_params
        params.require(:generation).permit(:status, box_requests_attributes: %i[ id box_packaging_id count ])
      end
  end
end
