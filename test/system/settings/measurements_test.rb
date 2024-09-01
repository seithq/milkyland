require "application_system_test_case"

class Settings::MeasurementsTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit measurements_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.measurements")
  end

  test "should create measurement" do
    visit measurements_url
    click_on I18n.t("actions.create_record")

    fill_in "measurement_name", with: "Pieces"
    fill_in "measurement_unit", with: "pcs"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Measurement" do
    visit measurements_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "measurement_name", with: "Pieces"
    fill_in "measurement_tonne_ratio", with: "1000"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end
end
