require "test_helper"

module Production
  class Plans::ProductionUnitsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @order = orders(:opening)
      assert @order.update preferred_date: 10.days.from_now
      @plan = Plan.last
      assert @plan.update status: :ready_to_production
      assert @plan.update status: :in_production
      @production_unit = @plan.units.last
    end

    test "should get index" do
      sign_in :daniyar
      get production_plan_units_url(@plan)
      assert_response :success
    end

    test "should show production_unit" do
      sign_in :daniyar
      get production_plan_unit_url(@plan, @production_unit)
      assert_response :success
    end

    test "should get edit" do
      sign_in :daniyar
      get edit_production_plan_unit_url(@plan, @production_unit)
      assert_response :success
    end

    test "should update production_unit" do
      sign_in :daniyar
      patch production_plan_unit_url(@plan, @production_unit), params: { production_unit: { comment: "Testing", status: :cancelled } }
      assert_redirected_to production_plan_unit_url(@plan, @production_unit)
    end
  end
end
