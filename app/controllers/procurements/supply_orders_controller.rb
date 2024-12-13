class Procurements::SupplyOrdersController < ApplicationController
  before_action :set_supply_order, only: %i[ show edit update ]
  before_action :set_form_vendors, only: %i[ new edit create update show ]
  before_action :set_search_vendors, only: :search

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
      GenerateTransactionForSupplyOrderJob.perform_later @supply_order.id, Current.user.id
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

  def search
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
      params.expect(supply_order: [ :material_asset_id, :amount, :payment_date, :payment_status, :delivery_status, :vendor_id ])
    end

    def set_form_vendors
      @vendors = @supply_order.nil? ? [] : @supply_order.material_asset.vendors
    end

    def set_search_vendors
      @vendors = unless params[:material_asset_id].present?
        []
      else
        Vendor.where(material_asset_id: params[:material_asset_id])
      end
    end
end
