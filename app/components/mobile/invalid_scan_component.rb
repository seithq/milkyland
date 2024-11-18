class Mobile::InvalidScanComponent < ApplicationComponent
  def initialize(qr_scan:)
    @qr_scan = qr_scan
    @reason  = @qr_scan.errors.full_messages.to_sentence
  end
end
