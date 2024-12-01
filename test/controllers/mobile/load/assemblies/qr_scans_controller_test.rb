require "test_helper"

module Mobile::Load
  class Assemblies::QrScansControllerTest < ActionDispatch::IntegrationTest
    setup do
      @zone = zones(:goods_ship_zone)
      @shipment = Shipment.create kind: :internal, client: clients(:systemd), region: regions(:almaty), shipping_date: Date.current
      @route_sheet = @shipment.route_sheets.create vehicle_plate_number: "272MNB02", driver_name: "Daniyar", driver_phone_number: "+77772514515"
      @tracking_product = @route_sheet.tracking_products.create product: products(:milk25), count: 6
      @assembly = Assembly.create zone: @zone, route_sheet: @route_sheet, user: users(:daniyar)
      sign_in :daniyar
    end

    test "should get index" do
      get load_assembly_qr_scans_url(@assembly)
      assert_response :success
    end

    test "should create qr_scan" do
      BoxGenerationJob.perform_now sample_generation.id

      assert_difference("QrScan.count") do
        post load_assembly_qr_scans_url(@assembly, format: :turbo_stream), params: { code: Box.last.code, allowed_prefixes: "P,B" }
      end

      assert_response :success
    end

    test "should destroy qr_scan" do
      BoxGenerationJob.perform_now sample_generation.id
      assert @assembly.add_qr Box.last.code, scanned_at: Time.current, allowed_prefixes: %w[ P B ]

      assert_difference("QrScan.count", -1) do
        delete load_assembly_qr_scan_url(@assembly, @assembly.qr_scans.last, format: :turbo_stream)
      end

      assert_response :success
    end
  end
end
