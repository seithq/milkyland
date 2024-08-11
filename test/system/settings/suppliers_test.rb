require "application_system_test_case"

class Settings::SuppliersTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit suppliers_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.contragents")
  end

  test "should create supplier" do
    visit suppliers_url
    click_on I18n.t("actions.create_record")

    select users(:askhat).name, from: "supplier_manager_id"
    fill_in "supplier_name", with: "REGATA"
    fill_in "supplier_bin", with: "921026400042"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update supplier" do
    visit suppliers_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "supplier_contact_person", with: "Aigerim"
    fill_in "supplier_email_address", with: "regata@mail.ru"
    fill_in "supplier_phone_number", with: "+77772098007"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end
end
