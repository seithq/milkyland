require "test_helper"

module Mobile
  class Load::AssembliesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @zone = zones(:goods_ship_zone)
      @shipment = Shipment.create kind: :internal, client: clients(:systemd), region: regions(:almaty), shipping_date: Date.current
      @route_sheet = @shipment.route_sheets.create vehicle_plate_number: "272MNB02", driver_name: "Daniyar", driver_phone_number: "+77772514515"
      @tracking_product = @route_sheet.tracking_products.create product: products(:milk25), count: 6
      @assembly = Assembly.create zone: @zone, route_sheet: @route_sheet, user: users(:daniyar)
      sign_in :daniyar
    end

    test "should get index" do
      get load_assemblies_url
      assert_response :success
    end

    test "should get new" do
      get new_load_assembly_url
      assert_response :success
    end

    test "should create assembly" do
      assert_difference("Assembly.count") do
        post load_assemblies_url, params: { assembly: { route_sheet_id: @assembly.route_sheet_id, zone_id: @zone.id } }
      end

      assert_redirected_to edit_load_assembly_url(Assembly.last)
    end

    test "should show assembly" do
      get load_assembly_url(@assembly)
      assert_response :success
    end

    test "should get edit" do
      get edit_load_assembly_url(@assembly)
      assert_response :success
    end

    test "should update assembly" do
      BoxGenerationJob.perform_now sample_generation.id
      assert Box.last.locate_to tiers(:goods_zone_line_stack_tier)
      @assembly.add_qr Box.last.code, scanned_at: Time.current

      patch load_assembly_url(@assembly), params: { assembly: { status: :approved } }
      assert_redirected_to load_assembly_url(@assembly)
    end

    test "should destroy assembly" do
      assert_difference("Assembly.count", -1) do
        delete load_assembly_url(@assembly)
      end

      assert_redirected_to load_assemblies_url
    end
  end
end
