require "test_helper"

module Production::Plans::ProductionUnits::Batches
  class Distributions::DistributedProductsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @order = orders(:opening)
      assert @order.update preferred_date: 10.days.from_now
      @plan = Plan.last
      assert @plan.update status: :ready_to_production
      assert @plan.update status: :in_production
      @production_unit = @plan.units.last
      assert @production_unit.batches.create(loader: users(:loader), tester: users(:tester), machiner: users(:machiner), operator: users(:operator))
      @batch = @production_unit.batches.last
      @journal = @production_unit.group.journals.last
      @operation = @journal.operations.last

      @packing = @batch.build_packing(status: :completed)
      @packing.build_products
      assert @packing.save

      @distribution = @batch.build_distribution(status: :in_progress)
      @distribution.build_products
      assert @distribution.save
      @distributed_product = @distribution.products.last
    end

    test "should get index" do
      sign_in :daniyar

      get production_plan_unit_batch_distribution_distributed_products_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should get edit" do
      sign_in :daniyar

      get edit_production_plan_unit_batch_distribution_distributed_product_url(@plan, @production_unit, @batch, @distributed_product)
      assert_response :success
    end

    test "should update distributed_product" do
      sign_in :daniyar

      patch production_plan_unit_batch_distribution_distributed_product_url(@plan, @production_unit, @batch, @distributed_product), params: { distributed_product: { count: @packing.products.last.count, production_date: @plan.production_date } }
      assert_redirected_to production_plan_unit_batch_distribution_url(@plan, @production_unit, @batch)
    end
  end
end
