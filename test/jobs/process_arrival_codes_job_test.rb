require "test_helper"

class ProcessArrivalCodesJobTest < ActiveJob::TestCase
  test "should create qr scans for arrival" do
    generation = sample_generation

    assert_difference "Box.count" do
      assert BoxGenerationJob.perform_now generation.id
    end

    assert PalletRequest.create generation: generation, count: 1
    assert_difference "Pallet.count" do
      assert PalletGenerationJob.perform_now PalletRequest.last.id
    end

    pallet, box = Pallet.last, Box.last
    assert box.locate_to pallet

    waybill = Waybill.new(new_storage: storages(:masters), sender: users(:daniyar), kind: :arrival, status: :draft)
    assert waybill.save

    assert_difference "waybill.qr_scans.count" do
      scans = waybill.add_qr pallet.code, scanned_at: Time.current
      assert_equal 1, scans.count
    end

    assert waybill.update status: :approved

    zone = waybill.new_storage.zones.filter_by_kind(:arrival).first
    assert_difference "waybill.leftovers.count" do
      assert_difference -> { zone.all_boxes.count }, 1 do
        assert ProcessArrivalCodesJob.perform_now waybill.id
      end
    end
  end
end
