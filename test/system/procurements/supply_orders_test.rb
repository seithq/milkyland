require "application_system_test_case"

class Procurements::SupplyOrdersTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit supply_orders_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.supply_orders")
  end

  test "should create procurements order" do
    visit supply_orders_url
    click_on I18n.t("actions.create_record")

    select material_assets(:сardboard).display_label, from: "supply_order_material_asset_id"
    select vendors(:сardboard).display_label, from: "supply_order_vendor_id"
    fill_in "supply_order_amount", with: 1000
    fill_in "supply_order_payment_date", with: 1.week.from_now
    click_on I18n.t("actions.save_record")

    assert_text material_assets(:сardboard).display_label
  end

  test "should update SupplyHelper order" do
    visit supply_orders_url
    click_on I18n.t("actions.edit_record"), match: :first

    select SupplyOrder.enum_to_s(:payment_status, :paid), from: "supply_order_payment_status"
    select SupplyOrder.enum_to_s(:delivery_status, :delivered), from: "supply_order_delivery_status"
    click_on I18n.t("actions.save_record")

    assert_text SupplyOrder.enum_to_s(:payment_status, :paid)
    assert_text SupplyOrder.enum_to_s(:delivery_status, :delivered)
  end
end
