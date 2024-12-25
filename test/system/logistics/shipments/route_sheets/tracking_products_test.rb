require "application_system_test_case"

module Logistics::Shipments
  class RouteSheets::TrackingProductsTest < ApplicationSystemTestCase
    setup do
      @shipment = Shipment.create kind: :internal, region: regions(:almaty), shipping_date: Date.current
      @route_sheet = @shipment.route_sheets.create vehicle_plate_number: "272MNB02", driver_name: "Daniyar", driver_phone_number: "+77772514515"
      @tracking_product = @route_sheet.tracking_products.create product: products(:milk25), count: 100
      sign_in "daniyar@hey.com"
    end

    test "should create tracking product" do
      visit edit_shipment_route_sheet_url(@shipment, @route_sheet)
      find(".new_tracking_product").click

      select products(:milk25_big).name, from: "tracking_product_product_id"
      fill_in "tracking_product_count", with: 100
      fill_in "tracking_product_unrestricted_count", with: 0
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Tracking product" do
      visit edit_shipment_route_sheet_url(@shipment, @route_sheet)
      find(".edit_tracking_product", match: :first).click

      fill_in "tracking_product_unrestricted_count", with: 10
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Tracking product" do
      visit edit_shipment_route_sheet_url(@shipment, @route_sheet)

      accept_alert do
        find(".destroy_tracking_product", match: :first).click
      end

      assert_no_text products(:milk25).name
    end
  end
end
