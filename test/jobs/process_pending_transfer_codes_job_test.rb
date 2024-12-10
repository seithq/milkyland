require "test_helper"

class ProcessPendingTransferCodesJobTest < ActiveJob::TestCase
  test "should create qr scans for transfer" do
    storage, new_storage = storages(:goods), storages(:masters)
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
    assert waybill.update status: :pending

    assert ProcessPendingTransferCodesJob.perform_now waybill.id
    assert_nil pallet.current_position
    assert_equal pallet, box.current_position
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
      assert pallet.locate_to storage.tiers.first
    end
end
