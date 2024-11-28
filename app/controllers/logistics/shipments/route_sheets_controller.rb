module Logistics
  class Shipments::RouteSheetsController < ApplicationController
    include ShipmentScoped, ReadModes

    before_action :set_route_sheet, only: %i[ show edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @route_sheets = base_scope
    end

    def show
    end

    def new
      @route_sheet = base_scope.new
    end

    def edit
    end

    def create
      @route_sheet = base_scope.new(route_sheet_params)

      if @route_sheet.save
        redirect_on_create edit_shipment_url(@shipment)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @route_sheet.update(route_sheet_params)
        redirect_on_update edit_shipment_url(@shipment)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @route_sheet.destroy!

      redirect_on_destroy shipment_route_sheets_url(@shipment)
    end

    private
      def base_scope
        @shipment.route_sheets.recent_first
      end

      def set_route_sheet
        @route_sheet = base_scope.find(params.expect(:id))
      end

      def route_sheet_params
        params.expect(route_sheet: %i[ vehicle_plate_number driver_name driver_phone_number comment ])
      end
  end
end
