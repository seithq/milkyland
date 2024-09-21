require "application_system_test_case"

module Production::Plans::ProductionUnits
  class Batches::JournalsTest < ApplicationSystemTestCase
    setup do
      sample_generation
      sign_in "daniyar@hey.com"
    end

    test "visiting the Journal" do
      visit production_plan_unit_batch_journal_url(@plan, @production_unit, @batch, @journal)
      assert_text @operation.name
    end
  end
end
