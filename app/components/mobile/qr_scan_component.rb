class Mobile::QrScanComponent < ApplicationComponent
  def initialize(qr_scan:, is_open:, readonly: false, with_capacity_input: false, with_animation: false)
    @qr_scan = qr_scan
    @is_open = is_open
    @readonly = readonly
    @with_capacity_input = with_capacity_input
    @with_animation = with_animation
  end

  private
    def title
      if @qr_scan.is_box?
        @qr_scan.code
      else
        "#{ @qr_scan.code } | #{ @qr_scan.box.code }"
      end
    end

    def policy
      return AssemblyPolicy if @qr_scan.groupable_type == "Assembly"

      case @qr_scan.groupable.kind
      when "arrival"
        ArrivalPolicy
      when "departure"
        DeparturePolicy
      when "write_off"
        WriteOffPolicy
      when "transfer"
        TransferPolicy
      else
        raise "Unsupported kind"
      end
    end

    def adjustable?
      return false if @qr_scan.groupable_type == "Assembly"

      case @qr_scan.groupable.kind
      when "arrival"
        false
      when "departure"
        true
      when "write_off"
        true
      when "transfer"
        helpers.allowed_to?(:approve?, @qr_scan.groupable, with: policy)
      else
        false
      end
    end

    def code_color
      return "text-green-600" if @qr_scan.groupable.draft?

      (@qr_scan.scanned? && @qr_scan.full?) ? "text-green-600" : "text-yellow-600"
    end

    def qr_scan_edit_url
      if @qr_scan.groupable_type == "Assembly"
        edit_load_assembly_qr_scan_path(@qr_scan.groupable, @qr_scan, format: :turbo_stream)
      else
        edit_waybills_qr_scan_path(@qr_scan.groupable, @qr_scan, format: :turbo_stream)
      end
    end

    def qr_scan_url
      if @qr_scan.groupable_type == "Assembly"
        load_assembly_qr_scan_path(@qr_scan.groupable, @qr_scan, format: :turbo_stream)
      else
        waybills_qr_scan_path(@qr_scan.groupable, @qr_scan, format: :turbo_stream)
      end
    end
end
