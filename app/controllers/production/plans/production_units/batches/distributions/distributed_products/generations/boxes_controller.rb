module Production::Plans::ProductionUnits::Batches::Distributions::DistributedProducts
  class Generations::BoxesController < ProductionController
    include PlanScoped, ProductionUnitScoped, BatchScoped, DistributionScoped, DistributedProductScoped, GenerationScoped

    def index
      @pagy, @boxes = pagy @generation.boxes
    end

    def download
      zipline build_zip_for(@generation), @generation.zip_name
    end

    private
      def build_zip_for(generation)
        if Rails.env.production?
          generation.boxes.map { |box| [box.qr_image.url, box.qr_image.filename] }
        else
          generation.boxes.map { |box| [box.qr_image, box.qr_image.filename] }
        end
      end
  end
end
