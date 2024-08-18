require "application_system_test_case"

class Settings::ClientsTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit clients_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.clients")
  end

  test "should create client" do
    visit clients_url
    click_on I18n.t("actions.create_record")

    select users(:askhat).name, from: "client_manager_id"
    fill_in "client_name", with: "REGATA"
    fill_in "client_bin", with: "921026400042"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Client" do
    visit clients_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "client_contact_person", with: "Aigerim"
    fill_in "client_email_address", with: "regata@mail.ru"
    fill_in "client_phone_number", with: "+77772098007"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end
end
