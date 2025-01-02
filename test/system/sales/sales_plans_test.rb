require "application_system_test_case"

class Sales::SalesPlansTest < ApplicationSystemTestCase
  setup do
    @sales_plan = sales_plans(:sales_opening)
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit sales_plans_url
    assert_selector ".breadcrumb-link", text: I18n.t("pages.sales_plans")
  end

  test "should create sales plan" do
    visit sales_plans_url
    click_on I18n.t("actions.create_record")

    select I18n.t("select.month_names")[Date.current.beginning_of_month.to_date.month], from: "sales_plan_month_2i"
    select regions(:aktobe).name, from: "sales_plan_region_id"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Sales plan" do
    visit sales_plans_url
    click_on I18n.t("actions.edit_record"), match: :first

    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end

  test "should destroy Sales plan" do
    visit edit_sales_plan_url(@sales_plan)

    accept_alert do
      find(".destroy_sales_plan", match: :first).click
    end

    assert_text I18n.t("actions.record_deleted")
  end
end
