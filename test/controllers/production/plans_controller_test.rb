require "test_helper"

class Production::PlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    sample_generation
    sign_in :daniyar
  end

  test "should get index" do
    get production_plans_url
    assert_response :success
  end

  test "should show plans" do
    get production_plans_url(@plan)
    assert_response :success
  end

  test "should get edit" do
    get edit_production_plan_url(@plan)
    assert_response :success
  end

  test "should update plans" do
    patch production_plan_url(@plan), params: { plan: { status: :cancelled, comment: "Testing" } }
    assert_redirected_to production_plan_url(@plan)
  end
end
