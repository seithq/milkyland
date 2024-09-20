require "test_helper"

module Production::Plans::ProductionUnits
  class Batches::PackingsControllerTest < ActionDispatch::IntegrationTest
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

    def create_package_for(batch)
      @packing = batch.build_packing(status: :in_progress)
      @packing.build_products
      assert @packing.save
    end

    test "should get new" do
      sign_in :daniyar

      get new_production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should redirect from new if package exists" do
      sign_in :daniyar
      create_package_for @batch

      get new_production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
      assert_redirected_to production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
    end

    test "should create packing" do
      sign_in :daniyar

      assert_difference("Packing.count") do
        post production_plan_unit_batch_packing_url(@plan, @production_unit, @batch), params: { packing: { status: :in_progress } }
      end

      assert_redirected_to production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
    end

    test "should show packing" do
      sign_in :daniyar
      create_package_for @batch

      get production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should redirect show new if package does not exist" do
      sign_in :daniyar

      get production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
      assert_redirected_to new_production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
    end

    test "should get edit" do
      sign_in :daniyar
      create_package_for @batch

      get edit_production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should update packing" do
      sign_in :daniyar
      create_package_for @batch

      patch production_plan_unit_batch_packing_url(@plan, @production_unit, @batch), params: { packing: { comment: "Testing", status: :cancelled } }
      assert_redirected_to production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
    end
  end
end
