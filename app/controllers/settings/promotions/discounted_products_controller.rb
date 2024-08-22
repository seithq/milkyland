module Settings
  class Promotions::DiscountedProductsController < ApplicationController
    include PromotionScoped, ReadModes

    before_action :ensure_can_administer, only: %i[ create update destroy ]
    before_action :set_discounted_product, only: %i[ edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @discounted_products = base_scope.recent_first
    end

    def new
      @discounted_product = base_scope.new
    end

    def edit
    end

    def create
      @discounted_product = base_scope.new(discounted_product_params)

      if @discounted_product.save
        redirect_on_create edit_promotion_url(@promotion)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @discounted_product.update(discounted_product_params)
        redirect_on_update edit_promotion_url(@promotion)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @discounted_product.deactivate

      redirect_on_destroy edit_promotion_url(@promotion)
    end

    private
      def base_scope
        @promotion.products
      end

      def search_methods
        []
      end

      def set_discounted_product
        @discounted_product = DiscountedProduct.find(params[:id])
      end

      def discounted_product_params
        params.require(:discounted_product).permit(:product_id, :active)
      end
  end
end
