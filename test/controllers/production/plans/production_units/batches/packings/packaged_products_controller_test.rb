require "test_helper"

module Production::Plans::ProductionUnits::Batches
  class Packings::PackagedProductsControllerTest < ActionDispatch::IntegrationTest
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

      @packing = @batch.build_packing(status: :in_progress)
      @packing.build_products
      assert @packing.save
      @packaged_product = @packing.products.last
    end

    test "should get index" do
      sign_in :daniyar

      get production_plan_unit_batch_packing_packaged_products_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should get edit" do
      sign_in :daniyar

      get edit_production_plan_unit_batch_packing_packaged_product_url(@plan, @production_unit, @batch, @packaged_product)
      assert_response :success
    end

    test "should update packaged_product" do
      sign_in :daniyar

      patch production_plan_unit_batch_packing_packaged_product_url(@plan, @production_unit, @batch, @packaged_product), params: { packaged_product: { start_time: 1.hour.ago, end_time: Time.zone.now } }
      assert_redirected_to production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
    end
  end
end
