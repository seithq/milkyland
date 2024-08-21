module Settings
  class Products::PricesController < ApplicationController
    include ProductScoped, ReadModes

    before_action :ensure_can_administer, only: %i[ create update destroy ]
    before_action :set_price, only: %i[ edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @prices = base_scope.recent_first
    end

    def new
      @price = base_scope.new
    end

    def edit
    end

    def create
      @price = base_scope.new(price_params)

      if @price.save
        redirect_on_create edit_product_url(@product)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
        if @price.update(price_params)
          redirect_on_update edit_product_url(@product)
        else
          render :edit, status: :unprocessable_entity
        end
    end

    def destroy
      @price.deactivate

      redirect_on_destroy edit_product_url(@product)
    end

    private
      def base_scope
        @product.prices
      end

      def search_methods
        []
      end

      def set_price
        @price = base_scope.find(params[:id])
      end

      def price_params
        params.require(:price).permit(:sales_channel_id, :value, :active)
      end
  end
end
