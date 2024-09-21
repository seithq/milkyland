require "test_helper"

module Production::Plans::ProductionUnits::Batches::Distributions
  class DistributedProducts::GenerationsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sample_generation
      sign_in :daniyar
    end

    test "should get new" do
      assert @generation.destroy

      get new_production_plan_unit_batch_distribution_distributed_product_generation_url(@plan, @production_unit, @batch, @distributed_product)
      assert_response :success
    end

    test "should redirect from new if generation exists" do
      get new_production_plan_unit_batch_distribution_distributed_product_generation_url(@plan, @production_unit, @batch, @distributed_product)
      assert_redirected_to production_plan_unit_batch_distribution_distributed_product_generation_url(@plan, @production_unit, @batch, @distributed_product)
    end

    test "should create generation" do
      assert @generation.destroy

      assert_difference("Generation.count") do
        post production_plan_unit_batch_distribution_distributed_product_generation_url(@plan, @production_unit, @batch, @distributed_product), params: { generation: { box_requests_attributes: [ { box_packaging_id: box_packagings(:bottle_milk25).id, count: 1 } ] } }
      end

      assert_redirected_to production_plan_unit_batch_distribution_distributed_product_generation_url(@plan, @production_unit, @batch, @distributed_product)
    end

    test "should show generation" do
      get production_plan_unit_batch_distribution_distributed_product_generation_url(@plan, @production_unit, @batch, @distributed_product)
      assert_response :success
    end
  end
end
