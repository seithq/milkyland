require "application_system_test_case"

class ConsolidationsTest < ApplicationSystemTestCase
  setup do
    @order = orders(:opening)
    assert @order.update(preferred_date: 10.days.from_now)
    @plan = Plan.last
    @consolidation = @plan.consolidations.last

    sign_in "daniyar@hey.com"
  end

  test "should update Consolidation" do
    assert @consolidation.deactivate

    visit edit_plan_url(@plan)
    find(".edit_consolidation", match: :first).click

    check "consolidation_active"
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end

  test "should destroy Consolidation" do
    visit edit_plan_url(@plan)

    accept_alert do
      find(".destroy_consolidation", match: :first).click
    end

    assert_text I18n.t("actions.order_deactivated")
  end
end
