require "application_system_test_case"

class Settings::SemiProductsTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit semi_products_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.semi_products")
  end

  test "should create semi product" do
    visit semi_products_url
    click_on I18n.t("actions.create_record")

    fill_in "semi_product_expiration_in_days", with: 3
    select groups(:bom_group).name, from: "semi_product_group_id"
    select measurements(:litre).display_label, from: "semi_product_measurement_id"
    fill_in "semi_product_name", with: "NEW BOM"
    fill_in "semi_product_storage_conditions", with: "3-6 celsius"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Semi product" do
    visit semi_products_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "semi_product_name", with: "NEW MILK"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end
end
