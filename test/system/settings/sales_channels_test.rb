require "application_system_test_case"

class Settings::SalesChannelsTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit sales_channels_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.channels")
  end

  test "should create sales channel" do
    visit sales_channels_url
    click_on I18n.t("actions.create_record")

    fill_in "sales_channel_name", with: "b2r"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Sales channel" do
    visit sales_channels_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "sales_channel_name", with: "b2r"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end
end
