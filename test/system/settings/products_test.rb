require "application_system_test_case"

class Settings::ProductsTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit products_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.products")
  end

  test "should create product" do
    visit products_url
    click_on I18n.t("actions.create_record")

    fill_in "product_article", with: "MTT"
    fill_in "product_expiration_in_days", with: 3
    fill_in "product_fat_fraction", with: 2.5
    select groups(:milk25).name, from: "product_group_id"
    select measurements(:litre).display_label, from: "product_measurement_id"
    fill_in "product_name", with: "KIDS MILK"
    fill_in "product_packing", with: 1
    fill_in "product_storage_conditions", with: "3-6 celsius"
    select material_assets(:bottle).name, from: "product_material_asset_id"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Product" do
    visit products_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "product_name", with: "NEW MILK"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end
end
