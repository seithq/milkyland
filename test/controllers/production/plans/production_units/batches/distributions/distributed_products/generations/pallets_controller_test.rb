require "test_helper"

module Production::Plans::ProductionUnits::Batches::Distributions::DistributedProducts
  class Generations::PalletsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @order = orders(:opening)
      assert @order.update preferred_date: 10.days.from_now
      @plan = Plan.last
      assert @plan.update status: :ready_to_production
      assert @plan.update status: :in_production
      @production_unit = @plan.units.last
      assert @production_unit.batches.create(loader: users(:loader), tester: users(:tester), machiner: users(:machiner), operator: users(:operator))
      @batch = @production_unit.batches.last

      @packing = @batch.build_packing(status: :completed)
      @packing.build_products
      assert @packing.save

      @distribution = @batch.build_distribution(status: :completed)
      @distribution.build_products
      assert @distribution.save
      @distributed_product = @distribution.products.last

      @generation = @distributed_product.build_generation(box_requests_attributes: [ { box_packaging_id: box_packagings(:bottle_milk25).id, count: 1 } ])
      assert @generation.save
    end

    test "should get index" do
      sign_in :daniyar

      get production_plan_unit_batch_distribution_distributed_product_generation_pallets_url(@plan, @production_unit, @batch, @distributed_product)
      assert_response :success
    end
  end
end
