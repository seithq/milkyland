require "test_helper"

class WaybillTest < ActiveSupport::TestCase
  test "should validate presence of storage" do
    waybill = Waybill.new(kind: :transfer, new_storage: storages(:material_assets_reserve), sender: users(:daniyar))
    assert waybill.invalid?
    assert_equal :blank, waybill.errors.where(:storage_id).first.type
  end

  test "should validate presence of new storage" do
    waybill = Waybill.new(kind: :arrival, sender: users(:daniyar))
    assert waybill.invalid?
    assert_equal :blank, waybill.errors.where(:new_storage_id).first.type
  end

  test "should validate presence of batch" do
    waybill = Waybill.new(kind: :production_write_off, storage: storages(:material_assets))
    assert waybill.invalid?
    assert_equal :blank, waybill.errors.where(:batch_id).first.type
  end

  test "should validate storage integrity" do
    waybill = waybills(:assets_transfer)
    assert_not waybill.update(new_storage: storages(:material_assets))
    assert_equal :inclusion, waybill.errors.where(:new_storage_id).first.type
  end

  test "should validate scope for material_assets" do
    waybills = Waybill.for_material_assets
    assert_equal 3, waybills.count
  end

  test "should validate balance of qr scans" do
    @waybill = prepare_transfer_waybill
    assert @waybill.update status: :pending
  end

  test "should validate presence of order" do
    waybill = Waybill.new kind: :departure, storage: storages(:goods), collectable: false
    assert waybill.invalid?
    assert :blank, waybill.errors.where(:order_id).first.type
  end

  test "should validate balance of qr scans if extra box added to zone" do
    @waybill = prepare_transfer_waybill

    @box = Box.create region: regions(:almaty),
                      product: products(:milk25),
                      capacity: 6,
                      production_date: 3.days.from_now,
                      expiration_date: 7.days.from_now
    assert @box.locate_to @assembly.zone
    assert @waybill.add_qr @box.code, scanned_at: Time.current

    assert_not @waybill.update status: :pending
  end

  test "should validate balance of qr scans if capacity has been changed" do
    @waybill = prepare_transfer_waybill

    assert @waybill.qr_scans.last.update capacity_after: 3
    assert_not @waybill.update status: :pending
  end

  private
    def prepare_transfer_waybill
      @generation = sample_generation

      assert BoxGenerationJob.perform_now @generation.id
      assert PalletRequest.create generation: @generation, count: 1
      assert PalletGenerationJob.perform_now PalletRequest.last.id

      @pallet, @box = Pallet.last, Box.last
      assert @box.locate_to @pallet

      @arrival = Waybill.create(new_storage: storages(:goods), sender: users(:daniyar), kind: :arrival, status: :approved)
      assert @arrival.add_qr @pallet.code, scanned_at: Time.current
      assert ProcessArrivalCodesJob.perform_now @arrival.id
      assert @pallet.locate_to storages(:goods).tiers.first

      @shipment = Shipment.create kind: :internal, region: regions(:almaty), shipping_date: Date.current
      @route_sheet = @shipment.route_sheets.create vehicle_plate_number: "272MNB02", driver_name: "Daniyar", driver_phone_number: "+77772514515"
      @tracking_product = @route_sheet.tracking_products.create product: products(:milk25), count: 6
      @assembly = Assembly.create zone: zones(:goods_ship_zone), route_sheet: @route_sheet, user: users(:daniyar)

      @waybill = Waybill.new kind: :transfer,
                             storage: storages(:goods),
                             new_storage: storages(:masters),
                             sender: users(:daniyar),
                             receiver: users(:warehouser),
                             collectable: true,
                             route_sheet_id: @route_sheet.id
      assert @waybill.save

      assert @assembly.add_qr Box.last.code, scanned_at: Time.current
      assert @assembly.update status: :approved
      assert @waybill.add_qr Box.last.code, scanned_at: Time.current

      @waybill
    end
end
