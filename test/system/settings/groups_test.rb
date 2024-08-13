require "application_system_test_case"

class Settings::GroupsTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit groups_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.groups")
  end

  test "should create group" do
    visit groups_url
    click_on I18n.t("actions.create_record")

    select categories(:milk).name, from: "group_category_id"
    fill_in "group_name", with: "New Milk"
    fill_in "group_metric_tonne", with: "1"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Group" do
    visit groups_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "group_name", with: "Kids Milk"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end
end
