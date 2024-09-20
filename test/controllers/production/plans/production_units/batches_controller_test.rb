require "test_helper"

module Production::Plans
  class ProductionUnits::BatchesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @order = orders(:opening)
      assert @order.update preferred_date: 10.days.from_now
      @plan = Plan.last
      assert @plan.update status: :ready_to_production
      assert @plan.update status: :in_production
      @production_unit = @plan.units.last
      assert @production_unit.batches.create(loader: users(:loader), tester: users(:tester), machiner: users(:machiner), operator: users(:operator))
      @batch = @production_unit.batches.last
    end

    test "should get index" do
      sign_in :daniyar
      get production_plan_unit_batches_url(@plan, @production_unit)
      assert_response :success
    end

    test "should get new" do
      sign_in :daniyar
      get new_production_plan_unit_batch_url(@plan, @production_unit)
      assert_response :success
    end

    test "should create batch" do
      sign_in :daniyar
      assert_difference("Batch.count") do
        post production_plan_unit_batches_url(@plan, @production_unit), params: { batch: { loader_id: users(:loader).id,
                                                                                           machiner_id: users(:machiner).id,
                                                                                           operator_id: users(:operator).id,
                                                                                           tester_id: users(:tester).id } }
      end

      assert_redirected_to production_plan_unit_url(@plan, @production_unit)
    end

    test "should show batch" do
      sign_in :daniyar
      get production_plan_unit_batch_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should get edit" do
      sign_in :daniyar
      get edit_production_plan_unit_batch_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should update batch" do
      sign_in :daniyar
      patch production_plan_unit_batch_url(@plan, @production_unit, @batch), params: { batch: { comment: "Testing", status: :cancelled } }
      assert_redirected_to production_plan_unit_batch_url(@plan, @production_unit, @batch)
    end
  end
end
