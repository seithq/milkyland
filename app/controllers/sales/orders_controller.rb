class Sales::OrdersController < ApplicationController
  include SalesChannelScoped

  before_action :set_order, only: %i[ show edit update destroy ]
  before_action :set_clients, only: %i[ show new edit ]

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
      redirect_on_create edit_sales_channel_order_path(@sales_channel, @order)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @order.update(order_params)
      redirect_on_update sales_channel_orders_url(@sales_channel)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order.cancel

    redirect_on_destroy sales_channel_orders_url(@sales_channel), text: t("actions.order_cancelled")
  end

  private
    def base_scope
      @sales_channel.orders.filter_by_status(@status).recent_first
    end

    def search_methods
      %i[ id_or_client_or_sales_point ]
    end

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:client_id, :sales_point_id, :kind, :preferred_date)
    end

    def set_clients
      if params.has_key?(:client_id)
        @clients = Client.where(id: params[:client_id])
      else
        @clients = Client.ordered
      end
    end
end
