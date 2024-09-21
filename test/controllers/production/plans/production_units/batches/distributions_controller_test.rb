require "test_helper"

module Production::Plans::ProductionUnits
  class Batches::DistributionsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sample_generation
      sign_in :daniyar
    end

    test "should get new" do
      assert @distribution.destroy

      get new_production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should redirect from new if distribution exists" do
      get new_production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
      assert_redirected_to production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
    end

    test "should create distribution" do
      assert @distribution.destroy

      assert_difference("Distribution.count") do
        post production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch), params: { distribution: { status: :in_progress } }
      end

      assert_redirected_to production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
    end

    test "should show distribution" do
      get production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should redirect show new if distribution does not exist" do
      assert @distribution.destroy

      get production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
      assert_redirected_to new_production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
    end

    test "should get edit" do
      get edit_production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should update distribution" do
      patch production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch), params: { distribution: { comment: "Testing", status: :cancelled } }
      assert_redirected_to production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
    end
  end
end
