require "test_helper"

class PlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:opening)
    assert @order.update(preferred_date: 10.days.from_now)
    @plan = Plan.last
  end

  test "should get index" do
    sign_in :daniyar
    get plans_url
    assert_response :success
  end

  test "should show plans" do
    sign_in :daniyar
    get plan_url(@plan)
    assert_response :success
  end

  test "should get edit" do
    sign_in :daniyar
    get edit_plan_url(@plan)
    assert_response :success
  end

  test "should update plans" do
    sign_in :daniyar
    patch plan_url(@plan), params: { plan: { status: :in_production } }
    assert_redirected_to plans_url(status: :in_production)
  end

  test "should destroy plans" do
    sign_in :daniyar
    assert_difference -> { Plan.filter_by_status(:cancelled).count }, 1 do
      delete plan_url(@plan)
    end

    assert_redirected_to plans_url(status: :cancelled)
  end
end
