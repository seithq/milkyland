require "test_helper"

module Mobile
  class Waybills::TransfersControllerTest < ActionDispatch::IntegrationTest
    setup do
      @storage = storages(:goods)
      @new_storage = storages(:masters)
      @shipment = Shipment.create kind: :internal, region: regions(:almaty), shipping_date: Date.current
      @route_sheet = @shipment.route_sheets.create vehicle_plate_number: "272MNB02", driver_name: "Daniyar", driver_phone_number: "+77772514515"
      @tracking_product = @route_sheet.tracking_products.create product: products(:milk25), count: 6
      @assembly = Assembly.create zone: zones(:goods_ship_zone), route_sheet: @route_sheet, user: users(:daniyar)
      @waybill = Waybill.create! kind: :transfer, storage: @storage, new_storage: @new_storage, sender: users(:daniyar), receiver: users(:warehouser), collectable: true, route_sheet_id: @route_sheet.id
      sign_in :daniyar
    end

    test "should get new" do
      get new_waybills_transfer_url
      assert_response :success
    end

    test "should create transfer" do
      assert_difference("Waybill.count") do
        post waybills_transfers_url, params: { waybill: { storage_id: @storage.id, new_storage_id: @new_storage.id, sender_id: users(:daniyar).id, receiver_id: users(:warehouser).id, collectable: true, route_sheet_id: @route_sheet.id } }
      end

      assert_redirected_to edit_waybills_transfer_url(Waybill.last)
    end

    test "should show transfer" do
      get waybills_transfer_url(@waybill)
      assert_response :success
    end

    test "should get edit" do
      get edit_waybills_transfer_url(@waybill)
      assert_response :success
    end

    test "should update transfer" do
      BoxGenerationJob.perform_now sample_generation.id
      assert Box.last.locate_to @storage.tiers.last

      assert @assembly.add_qr Box.last.code, scanned_at: Time.current
      assert @assembly.update status: :approved
      assert @waybill.add_qr Box.last.code, scanned_at: Time.current

      patch waybills_transfer_url(@waybill), params: { waybill: { collectable: true, status: :pending } }
      assert_redirected_to waybills_transfer_url(@waybill)
    end

    test "should destroy transfer" do
      assert_difference("Waybill.count", -1) do
        delete waybills_transfer_url(@waybill)
      end

      assert_redirected_to journals_outgoings_url
    end
  end
end
