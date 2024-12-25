module Logistics::Shipments
  class RouteSheets::TrackingProductsController < ApplicationController
    include ShipmentScoped, RouteSheetScoped, ReadModes

    before_action :set_tracking_product, only: %i[ show edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @tracking_products = base_scope
    end

    def show
    end

    def new
      @tracking_product = base_scope.new
    end

    def edit
    end

    def create
      @tracking_product = base_scope.new(tracking_product_params)

      if @tracking_product.save
        redirect_on_create edit_shipment_route_sheet_url(@shipment, @route_sheet)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @tracking_product.update(tracking_product_params)
        redirect_on_update edit_shipment_route_sheet_url(@shipment, @route_sheet)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @tracking_product.destroy!

      redirect_on_destroy shipment_route_sheet_tracking_products_url(@shipment, @route_sheet)
    end

    private
      def base_scope
        @route_sheet.tracking_products.recent_first
      end

      def set_tracking_product
        @tracking_product = base_scope.find(params.expect(:id))
      end

      def tracking_product_params
        params.expect(tracking_product: %i[ product_id count unrestricted_count ])
      end
  end
end
