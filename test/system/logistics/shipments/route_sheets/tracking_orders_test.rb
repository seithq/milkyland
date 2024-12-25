require "application_system_test_case"

module Logistics::Shipments
  class RouteSheets::TrackingOrdersTest < ApplicationSystemTestCase
    setup do
      @order = orders(:opening)
      @order.update kind: :unscheduled

      @shipment = Shipment.create kind: :external, client: clients(:systemd), region: regions(:almaty), shipping_date: Date.current
      @route_sheet = @shipment.route_sheets.create vehicle_plate_number: "272MNB02", driver_name: "Daniyar", driver_phone_number: "+77772514515"
      @tracking_order = @route_sheet.tracking_orders.create order: @order
      sign_in "daniyar@hey.com"
    end

    test "should create tracking order" do
      assert @route_sheet.tracking_orders.destroy_all

      visit edit_shipment_route_sheet_url(@shipment, @route_sheet)
      find(".new_tracking_order").click

      select orders(:opening).display_label, from: "tracking_order_order_id"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Tracking order" do
      visit edit_shipment_route_sheet_url(@shipment, @route_sheet)
      find(".edit_tracking_order", match: :first).click

      select orders(:opening).display_label, from: "tracking_order_order_id"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Tracking order" do
      visit edit_shipment_route_sheet_url(@shipment, @route_sheet)

      accept_alert do
        find(".destroy_tracking_order", match: :first).click
      end

      assert_no_text I18n.t("pages.tracking_order", id: @order.id)
    end
  end
end
