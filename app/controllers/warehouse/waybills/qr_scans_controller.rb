module Warehouse
  class Waybills::QrScansController < ApplicationController
    include WaybillScoped

    before_action :set_qr_scan, only: %i[ edit update ]

    def index
      @pagy, @qr_scans = pagy get_scope(params)
    end

    def edit
    end

    def update
      if @qr_scan.update(qr_scan_params)
        redirect_on_update edit_waybill_url(@waybill)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private
      def base_scope
        @waybill.qr_scans.recent_first
      end

      def set_qr_scan
        @qr_scan = base_scope.find(params.expect(:id))
      end

      def qr_scan_params
        params.expect(qr_scan: %i[ scanned_at capacity_after ])
      end
  end
end
