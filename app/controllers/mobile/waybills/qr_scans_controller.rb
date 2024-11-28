module Mobile
  class Waybills::QrScansController < MobileController
    include WaybillScoped

    before_action :set_allowed_prefixes, only: %i[ index create ]
    before_action :set_qr_scan, only: %i[ edit update destroy ]

    def index
      @qr_scans = base_scope
    end

    def edit
    end

    def create
      @qr_scans = create_or_replace_qr_scans
    end

    def update
      @qr_scan.update(qr_scan_edit_params)
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
        params.permit(:code, :allowed_prefixes, :action_name, :groupable_id, :groupable_type, qr_scan: [ :code ])
      end

      def qr_scan_edit_params
        params.expect(qr_scan: %i[ capacity_after scanned_at ])
      end

      def scan_time_for(waybill)
        waybill.transfer? ? nil : Time.current
      end

      def set_allowed_prefixes
        @allowed_prefixes = params[:allowed_prefixes].presence || "P,B"
      end

      def save_mode_for_scan
        @save_mode = qr_scan_params[:action_name].presence || "create"
      end

      def create_or_replace_qr_scans
        if save_mode_for_scan == "replace"
          scanned = @waybill.qr_scans.filter_by_scanning_code(qr_scan_params[:code])
          scanned.update_all scanned_at: Time.current
          scanned
        else
          @waybill.add_qr qr_scan_params[:code],
                          scanned_at: scan_time_for(@waybill),
                          allowed_prefixes: @allowed_prefixes.split(",")
        end
      end
  end
end
