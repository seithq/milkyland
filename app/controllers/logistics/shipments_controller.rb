class Logistics::ShipmentsController < ApplicationController
  before_action :set_status
  before_action :set_shipment, only: %i[ show edit update destroy ]

  def index
    @pagy, @shipments = pagy get_scope(params)
  end

  def show
  end

  def new
    @shipment = Shipment.new
  end

  def edit
  end

  def create
    @shipment = Shipment.new(shipment_params)

    if @shipment.save
      redirect_on_create shipments_url(status: @shipment.status)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @shipment.update(shipment_params)
      redirect_on_update shipments_url(status: @shipment.status)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shipment.destroy!

    redirect_on_destroy shipments_url
  end

  private
    def base_scope
      Shipment.filter_by_status(@status).ordered
    end

    def search_methods
      %i[ kind region client ]
    end

    def set_shipment
      @shipment = Shipment.find(params.expect(:id))
    end

    def shipment_params
      params.expect(shipment: %i[ plan_id region_id shipping_date kind status client_id ])
    end

    def set_status
      @status = params[:status].presence || "pending"
    end
end
