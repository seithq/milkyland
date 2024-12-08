require "application_system_test_case"

class Finance::TransactionsTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit transactions_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.transactions")
  end

  test "should create transaction" do
    visit transactions_url
    click_on I18n.t("actions.create_income")

    select bank_accounts(:milkyland_account).name, from: "transaction_bank_account_id"
    select articles(:operational_income_client).name, from: "transaction_article_id"
    select clients(:systemd).name, from: "transaction_client_id"
    fill_in "transaction_amount", with: 20000.0
    fill_in "transaction_planned_date", with: Date.current
    fill_in "transaction_comment", with: "Test"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Transaction" do
    visit transactions_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "transaction_amount", with: 20000.0
    fill_in "transaction_planned_date", with: Date.current
    fill_in "transaction_comment", with: "Test"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end

  test "should destroy Transaction" do
    visit transactions_url

    accept_alert do
      click_on I18n.t("actions.destroy_record"), match: :first
    end

    assert_text I18n.t("actions.record_cancelled")
  end
end
