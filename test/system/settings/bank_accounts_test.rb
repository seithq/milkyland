require "application_system_test_case"

class Settings::BankAccountsTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit bank_accounts_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.bank_accounts")
  end

  test "should create bank account" do
    visit bank_accounts_url
    click_on I18n.t("actions.create_record")

    select companies(:milkyland).name, from: "bank_account_company_id"
    fill_in "bank_account_name", with: "New Bank Account"
    fill_in "bank_account_number", with: "KZ007"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Bank account" do
    visit bank_accounts_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "bank_account_name", with: "New Name"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end

  test "should destroy Bank account" do
    visit bank_accounts_url

    accept_alert do
      click_on I18n.t("actions.destroy_record"), match: :first
    end

    assert_text I18n.t("actions.record_deleted")
  end
end
