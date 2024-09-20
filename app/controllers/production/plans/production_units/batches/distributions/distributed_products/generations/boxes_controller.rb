module Production::Plans::ProductionUnits::Batches::Distributions::DistributedProducts
  class Generations::BoxesController < ProductionController
    include PlanScoped, ProductionUnitScoped, BatchScoped, DistributionScoped, DistributedProductScoped, GenerationScoped

    def index
      @pagy, @boxes = pagy @generation.boxes
    end
  end
end
