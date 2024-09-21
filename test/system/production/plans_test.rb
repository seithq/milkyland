require "application_system_test_case"

class Production::PlansTest < ApplicationSystemTestCase
  setup do
    sample_generation
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit production_plans_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.production_plans")
  end

  test "should update Plan" do
    visit production_plans_url
    click_on I18n.t("actions.more"), match: :first

    click_on "plan-menu-button"
    click_on I18n.t("actions.force_finish")

    fill_in "plan_comment", with: "Testing"
    accept_alert do
      click_on I18n.t("actions.force_finish")
    end

    assert_text I18n.t("actions.record_updated")
  end
end
