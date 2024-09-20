module Production::Plans::ProductionUnits::Batches::Distributions::DistributedProducts
  class Generations::BoxesController < ProductionController
    include PlanScoped, ProductionUnitScoped, BatchScoped, DistributionScoped, DistributedProductScoped, GenerationScoped

    def index
      @pagy, @boxes = pagy @generation.boxes
    end

    def download
      images = @generation.boxes.map { |box| [ box.qr_image, box.qr_image.filename, modification_time: box.created_at ] }
      zipline images, @generation.zip_name
    end
  end
end
