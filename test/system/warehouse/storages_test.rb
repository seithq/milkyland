require "application_system_test_case"

class Warehouse::StoragesTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit storages_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.storages")
  end

  test "should create storage" do
    visit storages_url
    click_on I18n.t("actions.create_record")

    fill_in "storage_name", with: "New Storage"
    select Storage.enum_to_s(:kind, :for_goods), from: "storage_kind"
    click_on I18n.t("actions.save_record")

    assert_text "New Storage"
  end

  test "should update Storage" do
    visit storages_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "storage_name", with: "New Name"
    click_on I18n.t("actions.save_record")

    assert_text "New Name"
  end
end
