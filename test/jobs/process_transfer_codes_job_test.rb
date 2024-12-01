require "test_helper"

class ProcessTransferCodesJobTest < ActiveJob::TestCase
  test "should create qr scans for transfer" do
    storage, new_storage = storages(:masters), storages(:goods)
    prepare_arrival storage

    pallet, box = Pallet.last, Box.last

    waybill = Waybill.new(
      storage: storage,
      new_storage: new_storage,
      sender: users(:daniyar),
      receiver: users(:warehouser),
      kind: :transfer,
      status: :draft
    )
    assert waybill.save
    assert waybill.add_qr pallet.code, scanned_at: nil
    assert waybill.qr_scans.last.update capacity_after: 5

    assert_not waybill.update status: :approved

    assert waybill.qr_scans.last.update scanned_at: Time.current
    assert waybill.update status: :approved, manual_approval: true

    assert_difference -> { box.reload.capacity }, -1 do
      assert_difference -> { storage.available_count(box.product) }, -5.0 do
        assert_difference -> { new_storage.available_count(box.product) }, 5.0 do
          assert ProcessTransferCodesJob.perform_now waybill.id
          assert_equal zones(:masters_zone), pallet.current_position
          assert_equal zones(:goods_arrival_zone), box.current_position
        end
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
