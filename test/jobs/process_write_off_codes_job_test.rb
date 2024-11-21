require "test_helper"

class ProcessWriteOffCodesJobTest < ActiveJob::TestCase
  test "should create qr scans for write off for half capacity" do
    storage = storages(:masters)
    prepare_arrival storage

    pallet, box = Pallet.last, Box.last

    waybill = Waybill.new(storage: storage, sender: users(:daniyar), kind: :write_off, status: :draft)
    assert waybill.save

    assert waybill.add_qr pallet.code, scanned_at: Time.current
    assert waybill.qr_scans.last.update capacity_after: 3

    assert waybill.update status: :approved, manual_approval: true

    assert_difference -> { box.reload.capacity }, -3 do
      assert_difference -> { storage.available_count(box.product) }, -3.0 do
        assert ProcessWriteOffCodesJob.perform_now waybill.id
      end
    end
  end

  test "should create qr scans for write off for full capacity" do
    storage = storages(:masters)
    prepare_arrival storage

    pallet, box = Pallet.last, Box.last

    waybill = Waybill.new(storage: storage, sender: users(:daniyar), kind: :write_off, status: :draft)
    assert waybill.save

    assert waybill.add_qr pallet.code, scanned_at: Time.current

    assert waybill.update status: :approved
    capacity = box.capacity

    assert_difference -> { box.reload.capacity }, capacity * -1 do
      assert_difference -> { storage.available_count(box.product) }, capacity * -1.0 do
        assert ProcessWriteOffCodesJob.perform_now waybill.id
        assert_not box.current_position
      end
    end
  end

  private
    def prepare_arrival(storage)
      generation = sample_generation

      assert BoxGenerationJob.perform_now generation.id
      assert PalletRequest.create generation: generation, count: 1
      assert PalletGenerationJob.perform_now PalletRequest.last.id

      pallet, box = Pallet.last, Box.last
      assert box.locate_to pallet

      waybill = Waybill.create(new_storage: storage, sender: users(:daniyar), kind: :arrival, status: :approved)
      assert waybill.add_qr pallet.code, scanned_at: Time.current
      assert ProcessArrivalCodesJob.perform_now waybill.id
    end
end
