require "application_system_test_case"

module Logistics
  class Shipments::RouteSheetsTest < ApplicationSystemTestCase
    setup do
      @shipment = Shipment.create kind: :internal, client: clients(:systemd), region: regions(:almaty), shipping_date: Date.current
      @route_sheet = @shipment.route_sheets.create vehicle_plate_number: "272MNB02", driver_name: "Daniyar", driver_phone_number: "+77772514515"
      sign_in "daniyar@hey.com"
    end

    test "should create route sheet" do
      visit edit_shipment_url(@shipment)
      find(".new_route_sheet").click

      fill_in "route_sheet_vehicle_plate_number", with: "273GH02"
      fill_in "route_sheet_driver_name", with: "Aigerim"
      fill_in "route_sheet_driver_phone_number", with: "+77772098007"
      fill_in "route_sheet_comment", with: "TEST"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Route sheet" do
      visit edit_shipment_url(@shipment)
      find(".edit_route_sheet", match: :first).click

      fill_in "route_sheet_comment", with: "TEST"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Route sheet" do
      visit edit_shipment_url(@shipment)

      accept_alert do
        find(".destroy_route_sheet", match: :first).click
      end

      assert_no_text "272MNB02"
    end
  end
end
