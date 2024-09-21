require "test_helper"

module Production::Plans::ProductionUnits
  class Batches::PackingsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sample_generation
      sign_in :daniyar
    end

    test "should get new" do
      assert @packing.destroy

      get new_production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should redirect from new if package exists" do
      get new_production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
      assert_redirected_to production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
    end

    test "should create packing" do
      assert @packing.destroy

      assert_difference("Packing.count") do
        post production_plan_unit_batch_packing_url(@plan, @production_unit, @batch), params: { packing: { status: :in_progress } }
      end

      assert_redirected_to production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
    end

    test "should show packing" do
      get production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should redirect show new if package does not exist" do
      assert @packing.destroy

      get production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
      assert_redirected_to new_production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
    end

    test "should get edit" do
      get edit_production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should update packing" do
      patch production_plan_unit_batch_packing_url(@plan, @production_unit, @batch), params: { packing: { comment: "Testing", status: :cancelled } }
      assert_redirected_to production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
    end
  end
end
