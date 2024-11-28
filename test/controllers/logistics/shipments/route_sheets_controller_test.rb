require "test_helper"

module Logistics
  class Shipments::RouteSheetsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @shipment = Shipment.create kind: :internal, client: clients(:systemd), region: regions(:almaty), shipping_date: Date.current
      @route_sheet = @shipment.route_sheets.create vehicle_plate_number: "272MNB02", driver_name: "Daniyar", driver_phone_number: "+77772514515"
      sign_in :daniyar
    end

    test "should get index" do
      get shipment_route_sheets_url(@shipment)
      assert_response :success
    end

    test "should get new" do
      get new_shipment_route_sheet_url(@shipment)
      assert_response :success
    end

    test "should create route_sheet" do
      assert_difference("RouteSheet.count") do
        post shipment_route_sheets_url(@shipment), params: { route_sheet: { vehicle_plate_number: "273AGH02", driver_name: "Aigerim", driver_phone_number: "+77772098007" } }
      end

      assert_redirected_to edit_shipment_url(@shipment)
    end

    test "should show route_sheet" do
      get shipment_route_sheet_url(@shipment, @route_sheet)
      assert_response :success
    end

    test "should get edit" do
      get edit_shipment_route_sheet_url(@shipment, @route_sheet)
      assert_response :success
    end

    test "should update route_sheet" do
      patch shipment_route_sheet_url(@shipment, @route_sheet), params: { route_sheet: { comment: "TEST" } }
      assert_redirected_to edit_shipment_url(@shipment)
    end

    test "should destroy route_sheet" do
      assert_difference("RouteSheet.count", -1) do
        delete shipment_route_sheet_url(@shipment, @route_sheet)
      end

      assert_redirected_to shipment_route_sheets_url(@shipment)
    end
  end
end
