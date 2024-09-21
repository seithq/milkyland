require "test_helper"

module Production::Plans
  class ProductionUnits::BatchesControllerTest < ActionDispatch::IntegrationTest
    setup do
      sample_generation
      sign_in :daniyar
    end

    test "should get index" do
      get production_plan_unit_batches_url(@plan, @production_unit)
      assert_response :success
    end

    test "should get new" do
      get new_production_plan_unit_batch_url(@plan, @production_unit)
      assert_response :success
    end

    test "should create batch" do
      assert_difference("Batch.count") do
        post production_plan_unit_batches_url(@plan, @production_unit), params: { batch: { loader_id: users(:loader).id,
                                                                                           machiner_id: users(:machiner).id,
                                                                                           operator_id: users(:operator).id,
                                                                                           tester_id: users(:tester).id } }
      end

      assert_redirected_to production_plan_unit_url(@plan, @production_unit)
    end

    test "should show batch" do
      get production_plan_unit_batch_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should get edit" do
      get edit_production_plan_unit_batch_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should update batch" do
      patch production_plan_unit_batch_url(@plan, @production_unit, @batch), params: { batch: { comment: "Testing", status: :cancelled } }
      assert_redirected_to production_plan_unit_batch_url(@plan, @production_unit, @batch)
    end
  end
end
