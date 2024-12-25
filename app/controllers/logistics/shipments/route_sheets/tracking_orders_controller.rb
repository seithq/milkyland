module Logistics::Shipments
  class RouteSheets::TrackingOrdersController < ApplicationController
    include ShipmentScoped, RouteSheetScoped, ReadModes

    before_action :set_tracking_order, only: %i[ show edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @tracking_orders = base_scope
    end

    def show
    end

    def new
      @tracking_order = base_scope.new
    end

    def edit
    end

    def create
      @tracking_order = base_scope.new(tracking_order_params)

      if @tracking_order.save
        redirect_on_create edit_shipment_route_sheet_url(@shipment, @route_sheet)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @tracking_order.update(tracking_order_params)
        redirect_on_update edit_shipment_route_sheet_url(@shipment, @route_sheet)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @tracking_order.destroy!

      redirect_on_destroy edit_shipment_route_sheet_url(@shipment, @route_sheet)
    end

    private
      def base_scope
        @route_sheet.tracking_orders.recent_first
      end

      def set_tracking_order
        @tracking_order = base_scope.find(params.expect(:id))
      end

      def tracking_order_params
        params.expect(tracking_order: [ :order_id ])
      end
  end
end
