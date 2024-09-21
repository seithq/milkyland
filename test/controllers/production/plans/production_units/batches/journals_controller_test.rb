require "test_helper"

module Production::Plans::ProductionUnits
  class Batches::JournalsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sample_generation
      sign_in :daniyar
    end

    test "should show journal" do
      get production_plan_unit_batch_journal_url(@plan, @production_unit, @batch, @journal)
      assert_response :success
    end
  end
end
