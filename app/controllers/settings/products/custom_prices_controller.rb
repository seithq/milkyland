module Settings
  class Products::CustomPricesController < ApplicationController
    include ProductScoped, ReadModes

    before_action :ensure_can_administer, only: %i[ create update destroy ]
    before_action :set_custom_price, only: %i[ edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @custom_prices = base_scope
    end

    def new
      @custom_price = base_scope.new
    end

    def edit
    end

    def create
      @custom_price = base_scope.new(custom_price_params)

      if @custom_price.save
        redirect_on_create edit_product_url(@product)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @custom_price.update(custom_price_params)
        redirect_on_update edit_product_url(@product)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @custom_price.deactivate

      redirect_on_destroy edit_product_url(@product)
    end

    private
      def base_scope
        @product.custom_prices.recent_first
      end

      def set_custom_price
        @custom_price = base_scope.find(params.expect(:id))
      end

      def custom_price_params
        params.expect(custom_price: %i[ client_id value active ])
      end
  end
end
