require "application_system_test_case"

class Settings::FinancialCategoriesTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit financial_categories_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.financial_categories")
  end

  test "should create financial category" do
    visit financial_categories_url
    click_on I18n.t("actions.create_record")

    select FinancialCategory.enum_to_s(:kind, :expense), from: "financial_category_kind"
    fill_in "financial_category_name", with: "New Expense"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Financial category" do
    visit financial_categories_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "financial_category_name", with: "New Activity Type"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end

  test "should destroy Financial category" do
    visit financial_categories_url

    accept_alert do
      click_on I18n.t("actions.destroy_record"), match: :first
    end

    assert_text I18n.t("actions.record_deleted")
  end
end
