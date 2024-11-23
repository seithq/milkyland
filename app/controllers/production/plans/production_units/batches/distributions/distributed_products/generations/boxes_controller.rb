module Production::Plans::ProductionUnits::Batches::Distributions::DistributedProducts
  class Generations::BoxesController < ProductionController
    include PlanScoped, ProductionUnitScoped, BatchScoped, DistributionScoped, DistributedProductScoped, GenerationScoped, Zipable

    def index
      @pagy, @boxes = pagy @generation.boxes
    end

    private
      def init_download
        @generation.create_boxes_download kind: :boxes, status: :processing
      end

      def zip_class
        "Box"
      end

      def zip_scope
        @generation.boxes
      end

      def zip_name
        @generation.zip_name("B")
      end

      def post_download_url
        production_plan_unit_batch_distribution_distributed_product_generation_url(@plan, @production_unit, @batch, @distributed_product)
      end
  end
end
