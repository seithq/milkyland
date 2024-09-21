require "application_system_test_case"

class Sales::PlansTest < ApplicationSystemTestCase
  setup do
    @order = orders(:opening)
    assert @order.update(preferred_date: 10.days.from_now)
    @plan = Plan.last
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit plans_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.sales_by_plans")
  end

  test "should update Plan" do
    visit plans_url
    click_on I18n.t("actions.edit_record"), match: :first

    accept_alert do
      click_on I18n.t("actions.mark_for_production")
    end

    assert_text I18n.t("actions.record_updated")
  end

  test "should destroy Plan" do
    visit edit_plan_url(@plan)

    accept_alert do
      find(".destroy_plan", match: :first).click
    end

    assert_text I18n.t("actions.plan_cancelled")
  end
end
