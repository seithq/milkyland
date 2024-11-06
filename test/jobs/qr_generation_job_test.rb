require "test_helper"

class QrGenerationJobTest < ActiveJob::TestCase
  test "should generate qr code" do
    zone = zones(:goods_zone)
    assert QrGenerationJob.perform_now(zone)
    assert zone.qr_image.attached?
  end
end
