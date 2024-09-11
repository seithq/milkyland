require "test_helper"

class ProductionUnitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @production_unit = production_units(:one)
  end

  test "should get index" do
    get production_units_url
    assert_response :success
  end

  test "should get new" do
    get new_production_unit_url
    assert_response :success
  end

  test "should create production_unit" do
    assert_difference("ProductionUnit.count") do
      post production_units_url, params: { production_unit: { comment: @production_unit.comment, count: @production_unit.count, group_id: @production_unit.group_id, plan_id: @production_unit.plan_id, status: @production_unit.status, tonnage: @production_unit.tonnage } }
    end

    assert_redirected_to production_unit_url(ProductionUnit.last)
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

  test "should destroy production_unit" do
    assert_difference("ProductionUnit.count", -1) do
      delete production_unit_url(@production_unit)
    end

    assert_redirected_to production_units_url
  end
end
