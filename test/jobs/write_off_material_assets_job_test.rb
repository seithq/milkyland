require "test_helper"

class WriteOffMaterialAssetsJobTest < ActiveJob::TestCase
  setup do
    sample_generation
    assert @batch.update status: :completed
  end

  test "should create write off material assets" do
    assert_difference "Waybill.count" do
      assert_difference "Leftover.count", 4 do
        assert WriteOffMaterialAssetsJob.perform_now @batch.id
      end
    end
  end
end
