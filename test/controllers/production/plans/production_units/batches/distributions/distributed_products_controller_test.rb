require "test_helper"

module Production::Plans::ProductionUnits::Batches
  class Distributions::DistributedProductsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sample_generation
      sign_in :daniyar
    end

    test "should get index" do
      get production_plan_unit_batch_distribution_distributed_products_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should get edit" do
      get edit_production_plan_unit_batch_distribution_distributed_product_url(@plan, @production_unit, @batch, @distributed_product)
      assert_response :success
    end

    test "should update distributed_product" do
      patch production_plan_unit_batch_distribution_distributed_product_url(@plan, @production_unit, @batch, @distributed_product), params: { distributed_product: { count: @packing.products.last.count, production_date: @plan.production_date } }
      assert_redirected_to production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
    end
  end
end
