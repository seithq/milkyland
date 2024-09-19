module DistributedProductScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_distributed_product
  end

  private
    def set_distributed_product
      @distributed_product = DistributedProduct.find(params[:distributed_product_id])
    end
end
