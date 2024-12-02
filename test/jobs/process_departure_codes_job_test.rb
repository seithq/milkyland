require "test_helper"

class ProcessDepartureCodesJobTest < ActiveJob::TestCase
  test "should create qr scans for departure" do
    storage = storages(:goods)
    prepare_arrival storage

    pallet, box, route_sheet = Pallet.last, Box.last, RouteSheet.last

    waybill = Waybill.new(
      storage: storage,
      sender: users(:daniyar),
      kind: :departure,
      status: :draft,
      route_sheet: route_sheet,
      collectable: true
    )
    assert waybill.save
    assert waybill.add_qr zones(:goods_ship_zone).code, scanned_at: Time.current
    assert waybill.update status: :approved

    assert_difference -> { storage.available_count(box.product) }, -1.0 * box.capacity do
      assert ProcessDepartureCodesJob.perform_now waybill.id
      assert_equal tiers(:goods_zone_line_stack_tier), pallet.current_position
      assert_nil box.current_position
      assert box.reload.taken_out_at
      assert route_sheet.reload.completed?
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
      assert pallet.locate_to storage.tiers.last

      shipment = Shipment.create kind: :external, client: clients(:systemd), region: regions(:almaty), shipping_date: Date.current
      route_sheet = shipment.route_sheets.create vehicle_plate_number: "272MNB02", driver_name: "Daniyar", driver_phone_number: "+77772514515"
      route_sheet.tracking_products.create product: products(:milk25), count: box.capacity
      assembly = Assembly.create zone: zones(:goods_ship_zone), route_sheet: route_sheet, user: users(:daniyar)
      assert assembly.add_qr box.code, scanned_at: Time.current
      assert assembly.update status: :approved
      assert ProcessAssemblyCodesJob.perform_now assembly.id
    end
end
