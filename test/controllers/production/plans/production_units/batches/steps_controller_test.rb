require "test_helper"

module Production::Plans::ProductionUnits
  class Batches::StepsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sample_generation
      complete_journals @batch
      @step = @batch.steps.last
      sign_in :daniyar
    end

    test "should create step" do
      assert @batch.steps.destroy_all
      assert_difference("Step.count") do
        post production_plan_unit_batch_steps_url(@plan, @production_unit, @batch), params: { step: { operation_id: @operation.id, status: :in_progress } }
      end

      assert_redirected_to production_plan_unit_batch_journal_url(@plan, @production_unit, @batch, @journal)
    end

    test "should get edit" do
      get edit_production_plan_unit_batch_step_url(@plan, @production_unit, @batch, @step)
      assert_response :success
    end

    test "should update step" do
      patch production_plan_unit_batch_step_url(@plan, @production_unit, @batch, @step), params: { step: { comment: "Testing", status: :cancelled } }
      assert_redirected_to production_plan_unit_batch_journal_url(@plan, @production_unit, @batch, @journal)
    end
  end
end
