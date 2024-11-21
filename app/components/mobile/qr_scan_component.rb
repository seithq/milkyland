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
      case @qr_scan.waybill.kind
      when "arrival"
        ArrivalPolicy
      when "write_off"
        WriteOffPolicy
      when "transfer"
        TransferPolicy
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
      when "transfer"
        helpers.allowed_to?(:approve?, @qr_scan.waybill, with: policy)
      else
        false
      end
    end

    def code_color
      return "text-green-600" if @qr_scan.waybill.draft?

      (@qr_scan.scanned? && @qr_scan.full?) ? "text-green-600" : "text-yellow-600"
    end
end
