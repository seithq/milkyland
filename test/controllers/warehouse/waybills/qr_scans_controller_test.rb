require "test_helper"

class QrScansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @storage = storages(:masters)
    @waybill = Waybill.create! kind: :arrival, new_storage: @storage, sender: users(:daniyar)
    sign_in :daniyar
  end

  test "should get index" do
    get waybill_qr_scans_url(@waybill)
    assert_response :success
  end

  test "should get edit" do
    BoxGenerationJob.perform_now sample_generation.id
    assert @waybill.add_qr Box.last.code, scanned_at: Time.current, allowed_prefixes: %w[ P B ]

    get edit_waybill_qr_scan_url(@waybill, @waybill.qr_scans.last)
    assert_response :success
  end

  test "should update qr_scan" do
    BoxGenerationJob.perform_now sample_generation.id
    assert @waybill.add_qr Box.last.code, scanned_at: Time.current, allowed_prefixes: %w[ P B ]

    patch waybill_qr_scan_url(@waybill, @waybill.qr_scans.last), params: { qr_scan: { capacity_after: 5 } }
    assert_redirected_to edit_waybill_path(@waybill)
  end
end
