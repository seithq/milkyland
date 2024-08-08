require "application_system_test_case"

class RegionsTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit regions_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.regions")
  end

  test "should create region" do
    visit regions_url
    click_on I18n.t("actions.create_record")

    fill_in "region_code", with: "02"
    fill_in "region_name", with: "Almaty"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Region" do
    visit regions_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "region_name", with: "Almaty"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end
end
