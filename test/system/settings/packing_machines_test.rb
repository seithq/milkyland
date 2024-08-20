require "application_system_test_case"

class Settings::PackingMachinesTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit packing_machines_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.packing_machines")
  end

  test "should create packing machine" do
    visit packing_machines_url
    click_on I18n.t("actions.create_record")

    fill_in "packing_machine_name", with: "New Machine"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Packing machine" do
    visit packing_machines_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "packing_machine_name", with: "New Machine"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end
end
