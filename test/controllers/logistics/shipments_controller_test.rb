require "test_helper"

class Logistics::ShipmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shipment = Shipment.create kind: :internal, client: clients(:systemd), region: regions(:almaty), shipping_date: Date.current
    sign_in :daniyar
  end

  test "should get index" do
    get shipments_url
    assert_response :success
  end

  test "should get new" do
    get new_shipment_url
    assert_response :success
  end

  test "should create shipment" do
    assert_difference("Shipment.count") do
      post shipments_url, params: { shipment: { kind: :external, region_id: regions(:almaty).id, shipping_date: Date.current, client_id: clients(:systemd).id } }
    end

    assert_redirected_to edit_shipment_url(Shipment.last)
  end

  test "should show shipment" do
    get shipment_url(@shipment)
    assert_response :success
  end

  test "should get edit" do
    get edit_shipment_url(@shipment)
    assert_response :success
  end

  test "should update shipment" do
    patch shipment_url(@shipment), params: { shipment: { status: :ready_to_collect } }
    assert_redirected_to edit_shipment_url(@shipment)
  end

  test "should destroy shipment" do
    assert_difference("Shipment.count", -1) do
      delete shipment_url(@shipment)
    end

    assert_redirected_to shipments_url
  end
end
