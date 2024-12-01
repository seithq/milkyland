module Mobile::Load
  class Assemblies::QrScansController < MobileController
    include AssemblyScoped

    before_action :set_allowed_prefixes, only: %i[ index create ]
    before_action :set_qr_scan, only: %i[ edit update destroy ]

    def index
      @qr_scans = base_scope
    end

    def edit
    end

    def create
      @qr_scans = create_qr_scans
    end

    def update
      @qr_scan.update(qr_scan_edit_params)
    end

    def destroy
      @qr_scan.destroy!
    end

    private
      def base_scope
        @assembly.qr_scans.recent_first
      end

      def set_qr_scan
        @qr_scan = base_scope.find(params.expect(:id))
      end

      def qr_scan_params
        params.permit(:code, :allowed_prefixes, :action_name, :assembly_id, qr_scan: [ :code ])
      end

      def qr_scan_edit_params
        params.expect(qr_scan: %i[ capacity_after scanned_at ])
      end

      def set_allowed_prefixes
        @allowed_prefixes = params[:allowed_prefixes].presence || "P,B"
      end

      def create_qr_scans
        @assembly.add_qr qr_scan_params[:code],
                         scanned_at: Time.current,
                         allowed_prefixes: @allowed_prefixes.split(",")
      end
  end
end
