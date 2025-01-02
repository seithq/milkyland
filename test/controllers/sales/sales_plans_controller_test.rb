require "test_helper"

class Sales::SalesPlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sales_plan = sales_plans(:sales_opening)
    sign_in :daniyar
  end

  test "should get index" do
    get sales_plans_url
    assert_response :success
  end

  test "should get new" do
    get new_sales_plan_url
    assert_response :success
  end

  test "should create sales_plan" do
    assert_difference("SalesPlan.count") do
      post sales_plans_url, params: { sales_plan: { month: Date.current.beginning_of_month, region_id: regions(:aktobe).id } }
    end

    assert_redirected_to edit_sales_plan_url(SalesPlan.last)
  end

  test "should show sales_plan" do
    get sales_plan_url(@sales_plan)
    assert_response :success
  end

  test "should get edit" do
    get edit_sales_plan_url(@sales_plan)
    assert_response :success
  end

  test "should update sales_plan" do
    patch sales_plan_url(@sales_plan), params: { sales_plan: { estimations: [ { product_id: products(:milk25).id, sales_channel_id: sales_channels(:b2c).id, planned_count: 2 } ] } }
    assert_redirected_to edit_sales_plan_url(@sales_plan)
  end

  test "should destroy sales_plan" do
    assert_difference("SalesPlan.count", -1) do
      delete sales_plan_url(@sales_plan)
    end

    assert_redirected_to sales_plans_url
  end
end
