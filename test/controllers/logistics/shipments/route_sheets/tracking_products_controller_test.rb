require "test_helper"

module Logistics::Shipments
  class RouteSheets::TrackingProductsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @shipment = Shipment.create kind: :internal, client: clients(:systemd), region: regions(:almaty), shipping_date: Date.current
      @route_sheet = @shipment.route_sheets.create vehicle_plate_number: "272MNB02", driver_name: "Daniyar", driver_phone_number: "+77772514515"
      @tracking_product = @route_sheet.tracking_products.create product: products(:milk25), count: 100
      sign_in :daniyar
    end

    test "should get index" do
      get shipment_route_sheet_tracking_products_url(@shipment, @route_sheet)
      assert_response :success
    end

    test "should get new" do
      get new_shipment_route_sheet_tracking_product_url(@shipment, @route_sheet)
      assert_response :success
    end

    test "should create tracking_product" do
      assert_difference("TrackingProduct.count") do
        post shipment_route_sheet_tracking_products_url(@shipment, @route_sheet), params: { tracking_product: { count: 100, product_id: products(:milk25_big).id } }
      end

      assert_redirected_to edit_shipment_route_sheet_url(@shipment, @route_sheet)
    end

    test "should show tracking_product" do
      get shipment_route_sheet_tracking_product_url(@shipment, @route_sheet, @tracking_product)
      assert_response :success
    end

    test "should get edit" do
      get edit_shipment_route_sheet_tracking_product_url(@shipment, @route_sheet, @tracking_product)
      assert_response :success
    end

    test "should update tracking_product" do
      patch shipment_route_sheet_tracking_product_url(@shipment, @route_sheet, @tracking_product), params: { tracking_product: { unrestricted_count: 10 } }
      assert_redirected_to edit_shipment_route_sheet_url(@shipment, @route_sheet)
    end

    test "should destroy tracking_product" do
      assert_difference("TrackingProduct.count", -1) do
        delete shipment_route_sheet_tracking_product_url(@shipment, @route_sheet, @tracking_product)
      end

      assert_redirected_to shipment_route_sheet_tracking_products_url(@shipment, @route_sheet)
    end
  end
end
