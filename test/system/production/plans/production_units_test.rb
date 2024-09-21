require "application_system_test_case"

module Production
  class Plans::ProductionUnitsTest < ApplicationSystemTestCase
    setup do
      sample_generation
      sign_in "daniyar@hey.com"
    end

    test "visiting the index" do
      visit production_plan_units_url(@plan)
      assert_text @production_unit.group.name
    end

    test "should update Production unit" do
      visit production_plan_unit_url(@plan, @production_unit)

      click_on "unit-menu-button"
      click_on I18n.t("actions.force_finish")

      fill_in "production_unit_comment", with: "Testing"
      accept_alert do
        click_on I18n.t("actions.force_finish")
      end

      assert_text I18n.t("actions.record_updated")
    end
  end
end
