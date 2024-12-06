module Sales
  class Orders::PositionsController < ApplicationController
    include SalesChannelScoped, OrderScoped, ReadModes

    before_action :set_position, only: %i[ edit update destroy ]
    before_action :set_read_mode, only: :index
    before_action :set_product, only: %i[ new edit ]

    def index
      @positions = base_scope.recent_first
    end

    def new
      @position = base_scope.new(count: 1)
    end

    def edit
    end

    def create
      @position = base_scope.new(position_params)

      if @position.save
        redirect_on_create edit_sales_channel_order_url(@sales_channel, @order)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @position.update(position_params)
        redirect_on_update edit_sales_channel_order_url(@sales_channel, @order)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @position.destroy!

      redirect_on_destroy edit_sales_channel_order_url(@sales_channel, @order)
    end

    private
      def base_scope
        @order.positions
      end

      def search_methods
        []
      end

      def set_position
        @position = Position.find(params[:id])
      end

      def position_params
        params.require(:position).permit(:product_id, :promotion_id, :count, :base_price, :discounted_price, :total_sum)
      end

      def set_product
        if params.has_key?(:product_id)
          @product = Product.find(params[:product_id])
          @base_price = @product.price by: @sales_channel, client: @order.client_id

          @promotion = @order.eligible_promotions_for(@product).first
          @discounted_price = @promotion.present? ? @promotion.calculate_discount_for(@base_price) : @base_price.value
        end
      end
  end
end
