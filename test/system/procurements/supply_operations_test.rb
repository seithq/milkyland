require "application_system_test_case"

class Procurements::SupplyOperationsTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit supply_operations_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.supply_operations")
  end

  test "should create waybill" do
    visit supply_operations_url
    click_on I18n.t("actions.create_record")

    select Waybill.enum_to_s(:kind, :arrival), from: "waybill_kind"
    select storages(:material_assets).name, from: "waybill_new_storage_id"
    fill_in "waybill_comment", with: "TEST"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Waybill" do
    visit supply_operations_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "waybill_comment", with: "UPDATE"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end

  test "should destroy Waybill" do
    visit supply_operations_url
    click_on I18n.t("actions.edit_record"), match: :first

    accept_alert do
      click_on I18n.t("actions.destroy_record"), match: :first
    end

    assert_text I18n.t("actions.record_deactivated")
  end
end
