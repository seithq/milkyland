module GenerationScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_generation
  end

  private
    def set_generation
      @generation = DistributedProduct.find(params[:distributed_product_id]).generation
    end
end
