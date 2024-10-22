class Procurements::SupplyOrdersController < ApplicationController
  before_action :set_supply_order, only: %i[ show edit update ]

  def index
    @pagy, @supply_orders = pagy get_scope(params)
  end

  def show
  end

  def new
    @supply_order = base_scope.new
  end

  def edit
  end

  def create
    @supply_order = base_scope.new(supply_order_params)

    if @supply_order.save
      redirect_on_create supply_orders_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @supply_order.update(supply_order_params)
      redirect_on_update supply_orders_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def base_scope
      SupplyOrder.recent_first
    end

    def search_methods
      %i[ start_date end_date supplier payment_status delivery_status ]
    end

    def set_supply_order
      @supply_order = base_scope.find(params.expect(:id))
    end

    def supply_order_params
      params.expect(supply_order: [ :material_asset_id, :amount, :payment_date, :payment_status, :delivery_status ])
    end
end
