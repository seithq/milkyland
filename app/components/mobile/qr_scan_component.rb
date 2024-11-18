class Mobile::QrScanComponent < ApplicationComponent
  def initialize(qr_scan:, is_open:)
    @qr_scan = qr_scan
    @is_open = is_open
  end

  private
    def title
      if @qr_scan.is_box?
        @qr_scan.code
      else
        "#{ @qr_scan.code } | #{ @qr_scan.box.code }"
      end
    end
end
