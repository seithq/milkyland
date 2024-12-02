require "test_helper"

class ProcessTransferCodesJobTest < ActiveJob::TestCase
  test "should create qr scans for transfer" do
    storage, new_storage = storages(:goods), storages(:masters)
    prepare_arrival storage

    pallet, box, route_sheet = Pallet.last, Box.last, RouteSheet.last

    waybill = Waybill.new(
      storage: storage,
      new_storage: new_storage,
      sender: users(:daniyar),
      receiver: users(:warehouser),
      kind: :transfer,
      status: :draft,
      route_sheet: route_sheet,
      collectable: true
    )
    assert waybill.save
    assert waybill.add_qr zones(:goods_ship_zone).code, scanned_at: nil
    assert waybill.qr_scans.last.update capacity_after: 5

    assert_not waybill.update status: :pending
    assert route_sheet.tracking_products.last.update count: 5
    assert Assembly.last.qr_scans.last.update capacity_after: 5
    assert waybill.update status: :pending

    assert waybill.qr_scans.last.update scanned_at: Time.current
    assert waybill.update status: :approved, manual_approval: true

    assert_difference -> { box.reload.capacity }, -1 do
      assert_difference -> { storage.available_count(box.product) }, -5.0 do
        assert_difference -> { new_storage.available_count(box.product) }, 5.0 do
          assert ProcessTransferCodesJob.perform_now waybill.id
          assert_equal tiers(:goods_zone_line_stack_tier), pallet.current_position
          assert_equal zones(:masters_zone), box.current_position
          assert route_sheet.reload.completed?
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
      assert pallet.locate_to storage.tiers.first

      shipment = Shipment.create kind: :internal, region: regions(:aktobe), shipping_date: Date.current
      route_sheet = shipment.route_sheets.create vehicle_plate_number: "272MNB02", driver_name: "Daniyar", driver_phone_number: "+77772514515"
      route_sheet.tracking_products.create product: products(:milk25), count: box.capacity
      assembly = Assembly.create zone: zones(:goods_ship_zone), route_sheet: route_sheet, user: users(:daniyar)
      assert assembly.add_qr box.code, scanned_at: Time.current
      assert assembly.update status: :approved
      assert ProcessAssemblyCodesJob.perform_now assembly.id
    end
end
