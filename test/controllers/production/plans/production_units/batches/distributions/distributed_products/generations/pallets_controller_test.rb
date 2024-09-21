require "test_helper"

module Production::Plans::ProductionUnits::Batches::Distributions::DistributedProducts
  class Generations::PalletsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sample_generation
      sign_in :daniyar
    end

    test "should get index" do
      get production_plan_unit_batch_distribution_distributed_product_generation_pallets_url(@plan, @production_unit, @batch, @distributed_product)
      assert_response :success
    end
  end
end
