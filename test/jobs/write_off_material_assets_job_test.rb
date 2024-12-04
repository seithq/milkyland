require "test_helper"

class WriteOffMaterialAssetsJobTest < ActiveJob::TestCase
  setup do
    sample_generation
    assert @batch.update status: :completed
    assert @packaged_product.machineries.create packing_machine_id: packing_machines(:bottler).id,
                                                material_asset_id: material_assets(:bottle).id,
                                                count: @packaged_product.count,
                                                start_time: 1.hour.ago,
                                                end_time: Time.current
  end

  test "should create write off material assets" do
    assert_difference "Waybill.count" do
      assert_difference "Leftover.count", 5 do
        assert WriteOffMaterialAssetsJob.perform_now @batch.id
      end
    end
  end
end
