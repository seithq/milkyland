require "application_system_test_case"

class Settings::CompaniesTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit companies_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.companies")
  end

  test "should create company" do
    visit companies_url
    click_on I18n.t("actions.create_record")

    fill_in "company_name", with: "New Company"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Company" do
    visit companies_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "company_name", with: "New Company"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end

  test "should destroy Company" do
    visit companies_url

    accept_alert do
      click_on I18n.t("actions.destroy_record"), match: :first
    end

    assert_text I18n.t("actions.record_deleted")
  end
end
