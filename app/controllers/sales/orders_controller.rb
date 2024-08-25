class Sales::OrdersController < ApplicationController
  include ChannelScoped

  before_action :set_order, only: %i[ show edit update destroy ]

  def index
    @pagy, @orders = pagy get_scope(params)
  end

  def show
  end

  def new
    @order = base_scope.new
  end

  def edit
  end

  def create
    @order = base_scope.new(order_params)

    if @order.save
      redirect_on_create edit_channel_order_path(@order)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @order.update(order_params)
      redirect_on_update channel_orders_url(@channel)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order.cancel

    redirect_on_destroy channel_orders_url(@channel)
  end

  private
    def base_scope
      @channel.orders.recent_first
    end

    def search_methods
      []
    end

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:client_id, :sales_point_id, :kind, :status, :preferred_date)
    end
end
