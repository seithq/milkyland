require "test_helper"

class QrScansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @qr_scan = qr_scans(:one)
  end

  test "should get index" do
    get qr_scans_url
    assert_response :success
  end

  test "should get new" do
    get new_qr_scan_url
    assert_response :success
  end

  test "should create qr_scan" do
    assert_difference("QrScan.count") do
      post qr_scans_url, params: { qr_scan: {} }
    end

    assert_redirected_to qr_scan_url(QrScan.last)
  end

  test "should show qr_scan" do
    get qr_scan_url(@qr_scan)
    assert_response :success
  end

  test "should get edit" do
    get edit_qr_scan_url(@qr_scan)
    assert_response :success
  end

  test "should update qr_scan" do
    patch qr_scan_url(@qr_scan), params: { qr_scan: {} }
    assert_redirected_to qr_scan_url(@qr_scan)
  end

  test "should destroy qr_scan" do
    assert_difference("QrScan.count", -1) do
      delete qr_scan_url(@qr_scan)
    end

    assert_redirected_to qr_scans_url
  end
end
