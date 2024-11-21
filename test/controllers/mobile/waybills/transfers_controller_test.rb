require "test_helper"

module Mobile
  class Waybills::TransfersControllerTest < ActionDispatch::IntegrationTest
    setup do
      @storage = storages(:masters)
      @new_storage = storages(:goods)
      @waybill = Waybill.create! kind: :transfer, storage: @storage, new_storage: @new_storage, sender: users(:daniyar), receiver: users(:warehouser)
      sign_in :daniyar
    end

    test "should get new" do
      get new_waybills_transfer_url
      assert_response :success
    end

    test "should create transfer" do
      assert_difference("Waybill.count") do
        post waybills_transfers_url, params: { waybill: { storage_id: @storage.id, new_storage_id: @new_storage.id, sender_id: users(:daniyar).id, receiver_id: users(:warehouser).id  } }
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
      patch waybills_transfer_url(@waybill), params: { waybill: { status: :approved } }
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
