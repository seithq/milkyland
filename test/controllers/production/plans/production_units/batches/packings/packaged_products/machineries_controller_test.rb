require "test_helper"

module Production::Plans::ProductionUnits::Batches::Packings
  class PackagedProducts::MachineriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      sample_generation
      sign_in :daniyar
    end

    test "should get new" do
      get new_production_plan_unit_batch_packing_packaged_product_machinery_url(@plan, @production_unit, @batch, @packaged_product)
      assert_response :success
    end

    test "should create machinery" do
      assert_difference("Machinery.count") do
        post production_plan_unit_batch_packing_packaged_product_machineries_url(@plan, @production_unit, @batch, @packaged_product), params: { machinery: { packing_machine_id: packing_machines(:bottler).id, material_asset_id: material_assets(:bottle).id, count: @packaged_product.count, start_time: 1.hour.ago, end_time: Time.current } }
      end

      assert_redirected_to edit_production_plan_unit_batch_packing_packaged_product_url(@plan, @production_unit, @batch, @packaged_product)
    end

    test "should get edit" do
      @machinery = new_machinery
      get edit_production_plan_unit_batch_packing_packaged_product_machinery_url(@plan, @production_unit, @batch, @packaged_product, @machinery)
      assert_response :success
    end

    test "should update machinery" do
      @machinery = new_machinery
      patch production_plan_unit_batch_packing_packaged_product_machinery_url(@plan, @production_unit, @batch, @packaged_product, @machinery), params: { machinery: { start_time: 1.hour.ago } }
      assert_redirected_to edit_production_plan_unit_batch_packing_packaged_product_url(@plan, @production_unit, @batch, @packaged_product)
    end

    test "should destroy machinery" do
      @machinery = new_machinery
      assert_difference("Machinery.count", -1) do
        delete production_plan_unit_batch_packing_packaged_product_machinery_url(@plan, @production_unit, @batch, @packaged_product, @machinery)
      end

      assert_redirected_to edit_production_plan_unit_batch_packing_packaged_product_url(@plan, @production_unit, @batch, @packaged_product)
    end

    private
      def new_machinery
        @packaged_product.machineries.create(packing_machine_id: packing_machines(:bottler).id, material_asset_id: material_assets(:bottle).id, count: @packaged_product.count, start_time: 1.hour.ago, end_time: Time.current)
      end
  end
end
