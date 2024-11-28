require "test_helper"

class ShipmentGenerationJobTest < ActiveJob::TestCase
  setup do
    sample_generation
  end

  test "should generate shipment for production plan" do
    assert @plan.update status: :produced

    assert_difference "Shipment.count" do
      assert_difference "RouteSheet.count" do
        assert ShipmentGenerationJob.perform_now @plan.id
        assert_equal @plan.production_date, Shipment.last.shipping_date
        assert_equal @distributed_product.region_id, Shipment.last.region_id
      end
    end
  end
end
