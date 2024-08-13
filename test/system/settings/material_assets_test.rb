require "application_system_test_case"

class Settings::MaterialAssetsTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit material_assets_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.material_assets")
  end

  test "should create material asset" do
    visit material_assets_url
    click_on I18n.t("actions.create_record")

    fill_in "material_asset_name", with: "New Sugar"
    select categories(:raw).name, from: "material_asset_category_id"
    select suppliers(:systemd).name, from: "material_asset_supplier_id"
    fill_in "material_asset_article", with: "123"
    fill_in "material_asset_entry_price", with: "1000.00"
    fill_in "material_asset_packing", with: "25"
    select measurements(:kilogram).display_label, from: "material_asset_measurement_id"
    fill_in "material_asset_delivery_time_in_days", with: "15"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Material asset" do
    visit material_assets_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "material_asset_name", with: "New Sugar"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end
end
