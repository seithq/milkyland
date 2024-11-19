class Mobile::QrScanComponent < ApplicationComponent
  def initialize(qr_scan:, is_open:, readonly: false, with_capacity_input: false)
    @qr_scan = qr_scan
    @is_open = is_open
    @readonly = readonly
    @with_capacity_input = with_capacity_input
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
      case @qr_scan.waybill.kind
      when "arrival"
        ArrivalPolicy
      when "write_off"
        WriteOffPolicy
      else
        raise "Unsupported kind"
      end
    end

    def adjustable?
      case @qr_scan.waybill.kind
      when "arrival"
        false
      when "write_off"
        true
      else
        false
      end
    end
end
