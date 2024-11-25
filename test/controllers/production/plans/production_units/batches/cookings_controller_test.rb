require "test_helper"

class CookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sample_cooked_semi_product
    sign_in :daniyar
  end

  test "should get new" do
    assert @cooking.destroy

    get new_production_plan_unit_batch_cooking_url(@plan, @production_unit, @batch)
    assert_response :success
  end

  test "should redirect from new if package exists" do
    get new_production_plan_unit_batch_cooking_url(@plan, @production_unit, @batch)
    assert_redirected_to production_plan_unit_batch_cooking_url(@plan, @production_unit, @batch)
  end

  test "should create cooking" do
    assert @cooking.destroy

    assert_difference("Cooking.count") do
      post production_plan_unit_batch_cooking_url(@plan, @production_unit, @batch), params: { cooking: { status: :in_progress } }
    end

    assert_redirected_to production_plan_unit_batch_cooking_url(@plan, @production_unit, @batch)
  end

  test "should show cooking" do
    get production_plan_unit_batch_cooking_url(@plan, @production_unit, @batch)
    assert_response :success
  end

  test "should get edit" do
    get edit_production_plan_unit_batch_cooking_url(@plan, @production_unit, @batch)
    assert_response :success
  end

  test "should update cooking" do
    patch production_plan_unit_batch_cooking_url(@plan, @production_unit, @batch), params: { cooking: { comment: "Testing", status: :cancelled } }
    assert_redirected_to production_plan_unit_batch_cooking_url(@plan, @production_unit, @batch)
  end
end
