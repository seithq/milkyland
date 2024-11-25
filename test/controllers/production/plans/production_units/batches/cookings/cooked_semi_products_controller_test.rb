require "test_helper"

module Production::Plans::ProductionUnits::Batches
  class Cookings::CookedSemiProductsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sample_cooked_semi_product
      sign_in :daniyar
    end

    test "should get index" do
      get production_plan_unit_batch_cooking_cooked_semi_products_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should get edit" do
      get edit_production_plan_unit_batch_cooking_cooked_semi_product_url(@plan, @production_unit, @batch, @cooked_semi_product)
      assert_response :success
    end

    test "should update cooked_semi_product" do
      patch production_plan_unit_batch_cooking_cooked_semi_product_url(@plan, @production_unit, @batch, @cooked_semi_product), params: { cooked_semi_product: { tonnage: @cooked_semi_product.tonnage } }
      assert_redirected_to production_plan_unit_batch_cooking_url(@plan, @production_unit, @batch)
    end
  end
end
