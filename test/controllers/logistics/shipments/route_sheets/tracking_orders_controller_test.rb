require "test_helper"

module Logistics::Shipments
  class RouteSheets::TrackingOrdersControllerTest < ActionDispatch::IntegrationTest
    setup do
      @shipment = Shipment.create kind: :external, client: clients(:systemd), region: regions(:almaty), shipping_date: Date.current
      @route_sheet = @shipment.route_sheets.create vehicle_plate_number: "272MNB02", driver_name: "Daniyar", driver_phone_number: "+77772514515"
      @tracking_order = @route_sheet.tracking_orders.create order: orders(:opening)
      sign_in :daniyar
    end

    test "should get index" do
      get shipment_route_sheet_tracking_orders_url(@shipment, @route_sheet)
      assert_response :success
    end

    test "should get new" do
      get new_shipment_route_sheet_tracking_order_url(@shipment, @route_sheet)
      assert_response :success
    end

    test "should create tracking_order" do
      assert @route_sheet.tracking_orders.destroy_all
      assert_difference("TrackingOrder.count") do
        post shipment_route_sheet_tracking_orders_url(@shipment, @route_sheet), params: { tracking_order: { order_id: orders(:opening).id } }
      end

      assert_redirected_to edit_shipment_route_sheet_url(@shipment, @route_sheet)
    end

    test "should show tracking_order" do
      get shipment_route_sheet_tracking_order_url(@shipment, @route_sheet, @tracking_order)
      assert_response :success
    end

    test "should get edit" do
      get edit_shipment_route_sheet_tracking_order_url(@shipment, @route_sheet, @tracking_order)
      assert_response :success
    end

    test "should update tracking_order" do
      patch shipment_route_sheet_tracking_order_url(@shipment, @route_sheet, @tracking_order), params: { tracking_order: { order_id: orders(:opening).id } }
      assert_redirected_to edit_shipment_route_sheet_url(@shipment, @route_sheet)
    end

    test "should destroy tracking_order" do
      assert_difference("TrackingOrder.count", -1) do
        delete shipment_route_sheet_tracking_order_url(@shipment, @route_sheet, @tracking_order)
      end

      assert_redirected_to edit_shipment_route_sheet_url(@shipment, @route_sheet)
    end
  end
end
