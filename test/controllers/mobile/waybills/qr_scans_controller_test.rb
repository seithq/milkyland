require "test_helper"

module Mobile
  class Waybills::QrScansControllerTest < ActionDispatch::IntegrationTest
    setup do
      @storage = storages(:masters)
      @waybill = Waybill.create! kind: :arrival, new_storage: @storage, sender: users(:daniyar)
      sign_in :daniyar
    end

    test "should get index" do
      get waybills_qr_scans_url(@waybill)
      assert_response :success
    end

    test "should create qr_scan" do
      BoxGenerationJob.perform_now sample_generation.id

      assert_difference("QrScan.count") do
        post waybills_qr_scans_url(@waybill, format: :turbo_stream), params: { code: Box.last.code, allowed_prefixes: "P,B" }
      end

      assert_response :success
    end

    test "should get edit" do
      BoxGenerationJob.perform_now sample_generation.id
      assert @waybill.add_qr Box.last.code, scanned_at: Time.current, allowed_prefixes: %w[ P B ]

      get edit_waybills_qr_scan_url(@waybill, @waybill.qr_scans.last, format: :turbo_stream)
      assert_response :success
    end

    test "should update qr_scan" do
      BoxGenerationJob.perform_now sample_generation.id
      assert @waybill.add_qr Box.last.code, scanned_at: Time.current, allowed_prefixes: %w[ P B ]

      patch waybills_qr_scan_url(@waybill, @waybill.qr_scans.last, format: :turbo_stream), params: { qr_scan: { capacity_after: 4 } }
      assert_response :success
    end

    test "should destroy qr_scan" do
      BoxGenerationJob.perform_now sample_generation.id
      assert @waybill.add_qr Box.last.code, scanned_at: Time.current, allowed_prefixes: %w[ P B ]

      assert_difference("QrScan.count", -1) do
        delete waybills_qr_scan_url(@waybill, @waybill.qr_scans.last, format: :turbo_stream)
      end

      assert_response :success
    end
  end
end
