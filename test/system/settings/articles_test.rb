require "application_system_test_case"

class ArticlesTest < ApplicationSystemTestCase
  setup do
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit articles_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.articles")
  end

  test "should create article" do
    visit articles_url
    click_on I18n.t("actions.create_expense")

    select activity_types(:operational).name, from: "article_activity_type_id"
    select financial_categories(:expense_tax).name, from: "article_financial_category_id"
    fill_in "article_name", with: "New Article Name"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Article" do
    visit articles_url
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "article_name", with: "New Article Name"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end

  test "should destroy Article" do
    visit articles_url

    accept_alert do
      click_on I18n.t("actions.destroy_record"), match: :first
    end

    assert_text I18n.t("actions.record_deleted")
  end
end
