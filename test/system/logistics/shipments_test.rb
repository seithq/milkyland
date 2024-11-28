require "application_system_test_case"

class Logistics::ShipmentsTest < ApplicationSystemTestCase
  setup do
    @shipment = Shipment.create kind: :internal, client: clients(:systemd), region: regions(:almaty), shipping_date: Date.current
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit shipments_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.shipments")
  end

  test "should create shipment" do
    visit shipments_url
    click_on I18n.t("actions.create_record")

    select Shipment.enum_to_s(:kind, :external), from: "shipment_kind"
    select regions(:almaty).name, from: "shipment_region_id"
    select clients(:systemd).name, from: "shipment_client_id"
    fill_in "shipment_shipping_date", with: Date.current
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Shipment" do
    visit shipments_url
    click_on I18n.t("actions.edit_record"), match: :first

    select Shipment.enum_to_s(:status, :ready_to_collect), from: "shipment_status"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end

  test "should destroy Shipment" do
    visit edit_shipment_url(@shipment)

    accept_alert do
      find(".destroy_shipment", match: :first).click
    end

    assert_text I18n.t("actions.record_deleted")
  end
end
