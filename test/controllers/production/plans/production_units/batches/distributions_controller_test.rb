require "test_helper"

module Production::Plans::ProductionUnits
  class Batches::DistributionsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @order = orders(:opening)
      assert @order.update preferred_date: 10.days.from_now
      @plan = Plan.last
      assert @plan.update status: :ready_to_production
      assert @plan.update status: :in_production
      @production_unit = @plan.units.last
      assert @production_unit.batches.create(loader: users(:loader), tester: users(:tester), machiner: users(:machiner), operator: users(:operator))
      @batch = @production_unit.batches.last

      @packing = @batch.build_packing(status: :completed)
      @packing.build_products
      assert @packing.save
    end

    def create_distribution_for(batch)
      @distribution = batch.build_distribution(status: :in_progress)
      @distribution.build_products
      assert @distribution.save
    end

    test "should get new" do
      sign_in :daniyar

      get new_production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should redirect from new if distribution exists" do
      sign_in :daniyar
      create_distribution_for @batch

      get new_production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
      assert_redirected_to production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
    end

    test "should create distribution" do
      sign_in :daniyar

      assert_difference("Distribution.count") do
        post production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch), params: { distribution: { status: :in_progress } }
      end

      assert_redirected_to production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
    end

    test "should show distribution" do
      sign_in :daniyar
      create_distribution_for @batch

      get production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should redirect show new if distribution does not exist" do
      sign_in :daniyar

      get production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
      assert_redirected_to new_production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
    end

    test "should get edit" do
      sign_in :daniyar
      create_distribution_for @batch

      get edit_production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should update distribution" do
      sign_in :daniyar
      create_distribution_for @batch

      patch production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch), params: { distribution: { comment: "Testing", status: :cancelled } }
      assert_redirected_to production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
    end
  end
end
