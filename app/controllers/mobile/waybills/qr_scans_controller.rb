module Mobile
  class Waybills::QrScansController < MobileController
    include WaybillScoped

    before_action :set_allowed_prefixes, only: %i[ index create ]
    before_action :set_qr_scan, only: %i[ destroy ]

    def index
      @qr_scans = base_scope
    end

    def create
      @qr_scans = @waybill.add_qr qr_scan_params[:code],
                                  scanned_at: scan_time_for(@waybill),
                                  allowed_prefixes: @allowed_prefixes.split(",")
    end

    def destroy
      @qr_scan.destroy!
    end

    private
      def base_scope
        @waybill.qr_scans.recent_first
      end

      def set_qr_scan
        @qr_scan = base_scope.find(params.expect(:id))
      end

      def qr_scan_params
        params.permit(:code, :allowed_prefixes)
      end

      def scan_time_for(waybill)
        waybill.transfer? ? nil : Time.current
      end

      def set_allowed_prefixes
        @allowed_prefixes = params[:allowed_prefixes].presence || "P,B"
      end
  end
end
