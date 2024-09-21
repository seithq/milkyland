require "test_helper"

module Production
  class Plans::ProductionUnitsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sample_generation
      sign_in :daniyar
    end

    test "should get index" do
      get production_plan_units_url(@plan)
      assert_response :success
    end

    test "should show production_unit" do
      get production_plan_unit_url(@plan, @production_unit)
      assert_response :success
    end

    test "should get edit" do
      get edit_production_plan_unit_url(@plan, @production_unit)
      assert_response :success
    end

    test "should update production_unit" do
      patch production_plan_unit_url(@plan, @production_unit), params: { production_unit: { comment: "Testing", status: :cancelled } }
      assert_redirected_to production_plan_unit_url(@plan, @production_unit)
    end
  end
end
