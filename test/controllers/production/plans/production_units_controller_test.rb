require "test_helper"

module Production
  class Plans::ProductionUnitsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @production_unit = production_units(:one)
    end

    test "should get index" do
      get production_units_url
      assert_response :success
    end

    test "should show production_unit" do
      get production_unit_url(@production_unit)
      assert_response :success
    end

    test "should get edit" do
      get edit_production_unit_url(@production_unit)
      assert_response :success
    end

    test "should update production_unit" do
      patch production_unit_url(@production_unit), params: { production_unit: { comment: @production_unit.comment, count: @production_unit.count, group_id: @production_unit.group_id, plan_id: @production_unit.plan_id, status: @production_unit.status, tonnage: @production_unit.tonnage } }
      assert_redirected_to production_unit_url(@production_unit)
    end
  end
end
