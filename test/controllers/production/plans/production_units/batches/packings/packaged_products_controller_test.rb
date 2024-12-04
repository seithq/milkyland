require "test_helper"

module Production::Plans::ProductionUnits::Batches
  class Packings::PackagedProductsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sample_generation
      sign_in :daniyar
    end

    test "should get index" do
      get production_plan_unit_batch_packing_packaged_products_url(@plan, @production_unit, @batch)
      assert_response :success
    end

    test "should get edit" do
      get edit_production_plan_unit_batch_packing_packaged_product_url(@plan, @production_unit, @batch, @packaged_product)
      assert_response :success
    end

    test "should update packaged_product" do
      assert @packaged_product.machineries.create packing_machine_id: packing_machines(:bottler).id,
                                                  material_asset_id: material_assets(:bottle).id,
                                                  count: @packaged_product.count,
                                                  start_time: 1.hour.ago,
                                                  end_time: Time.current

      patch production_plan_unit_batch_packing_packaged_product_url(@plan, @production_unit, @batch, @packaged_product), params: { packaged_product: { start_time: 1.hour.ago, end_time: Time.current } }
      assert_redirected_to production_plan_unit_batch_packing_url(@plan, @production_unit, @batch)
    end
  end
end
