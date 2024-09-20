require "test_helper"

class Production::PlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:opening)
    assert @order.update preferred_date: 10.days.from_now
    @plan = Plan.last
    assert @plan.update status: :ready_to_production
  end

  test "should get index" do
    sign_in :daniyar
    get production_plans_url
    assert_response :success
  end

  test "should show plans" do
    sign_in :daniyar
    get production_plans_url(@plan)
    assert_response :success
  end

  test "should get edit" do
    sign_in :daniyar
    get edit_production_plan_url(@plan)
    assert_response :success
  end

  test "should update plans" do
    sign_in :daniyar
    patch production_plan_url(@plan), params: { plan: { status: :cancelled, comment: "Testing" } }
    assert_redirected_to production_plan_url(@plan)
  end
end
