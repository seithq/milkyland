module PackagedProductScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_packaged_product
  end

  private
    def set_packaged_product
      @packaged_product = PackagedProduct.find(params[:packaged_product_id])
    end
end
