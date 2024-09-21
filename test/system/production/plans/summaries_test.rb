require "application_system_test_case"

module Production
  class Plans::ConsolidationsTest < ApplicationSystemTestCase
    setup do
      sample_generation
      sign_in "daniyar@hey.com"
    end

    test "visiting the index" do
      visit production_plan_summary_url(@plan, card_view: true)
      assert_text @production_unit.group.name
    end
  end
end
