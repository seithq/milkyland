require "test_helper"

module Production::Plans::ProductionUnits
  class Batches::StepsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @order = orders(:opening)
      assert @order.update preferred_date: 10.days.from_now
      @plan = Plan.last
      assert @plan.update status: :ready_to_production
      assert @plan.update status: :in_production
      @production_unit = @plan.units.last
      assert @production_unit.batches.create(loader: users(:loader), tester: users(:tester), machiner: users(:machiner), operator: users(:operator))
      @batch = @production_unit.batches.last
      @journal = @production_unit.group.journals.last
      @operation = @journal.operations.last
      assert @batch.steps.create(operation: @operation, status: :in_progress)
      @step = @batch.steps.last
    end

    test "should create step" do
      sign_in :daniyar

      assert @batch.steps.destroy_all
      assert_difference("Step.count") do
        post production_plan_unit_batch_steps_url(@plan, @production_unit, @batch), params: { step: { operation_id: @operation.id, status: :in_progress } }
      end

      assert_redirected_to production_plan_unit_batch_journal_url(@plan, @production_unit, @batch, @journal)
    end

    test "should get edit" do
      sign_in :daniyar

      get edit_production_plan_unit_batch_step_url(@plan, @production_unit, @batch, @step)
      assert_response :success
    end

    test "should update step" do
      sign_in :daniyar

      patch production_plan_unit_batch_step_url(@plan, @production_unit, @batch, @step), params: { step: { comment: "Testing", status: :cancelled } }
      assert_redirected_to production_plan_unit_batch_journal_url(@plan, @production_unit, @batch, @journal)
    end
  end
end
