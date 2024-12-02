require "test_helper"

module Mobile::Load
  class Assemblies::QrScansControllerTest < ActionDispatch::IntegrationTest
    setup do
      @storage = storages(:goods)
      @assembly = prepare_assembly @storage
      sign_in :daniyar
    end

    test "should get index" do
      get load_assembly_qr_scans_url(@assembly)
      assert_response :success
    end

    test "should create qr_scan" do
      assert_difference("QrScan.count") do
        post load_assembly_qr_scans_url(@assembly, format: :turbo_stream), params: { code: Box.last.code, allowed_prefixes: "P,B" }
      end

      assert_response :success
    end

    test "should destroy qr_scan" do
      assert @assembly.add_qr Box.last.code, scanned_at: Time.current, allowed_prefixes: %w[ P B ]

      assert_difference("QrScan.count", -1) do
        delete load_assembly_qr_scan_url(@assembly, @assembly.qr_scans.last, format: :turbo_stream)
      end

      assert_response :success
    end

    private
      def prepare_assembly(storage)
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

        shipment = Shipment.create kind: :internal, region: regions(:almaty), shipping_date: Date.current
        route_sheet = shipment.route_sheets.create vehicle_plate_number: "272MNB02", driver_name: "Daniyar", driver_phone_number: "+77772514515"
        route_sheet.tracking_products.create product: products(:milk25), count: box.capacity
        Assembly.create zone: zones(:goods_ship_zone), route_sheet: route_sheet, user: users(:daniyar)
      end
  end
end
