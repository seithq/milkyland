require "application_system_test_case"

class Settings::CategoriesTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit categories_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.categories")
  end

  test "should create category" do
    visit categories_url
    click_on I18n.t("actions.create_record")

    fill_in "category_name", with: "Yogurt"
    select Category.enum_to_s(:kind, :end_product), from: "category_kind"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Category" do
    visit categories_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "category_name", with: "Yogurt"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end
end
