require "application_system_test_case"

class Settings::ActivityTypesTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit activity_types_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.activity_types")
  end

  test "should create activity type" do
    visit activity_types_url
    click_on I18n.t("actions.create_record")

    fill_in "activity_type_name", with: "New Activity Type"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Activity type" do
    visit activity_types_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "activity_type_name", with: "New Activity Type"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end

  test "should destroy Activity type" do
    assert Article.destroy_all
    visit activity_types_url

    accept_alert do
      click_on I18n.t("actions.destroy_record"), match: :first
    end

    assert_text I18n.t("actions.record_deleted")
  end
end
