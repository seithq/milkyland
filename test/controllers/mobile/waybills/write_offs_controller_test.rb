require "test_helper"

module Mobile
  class Waybills::WriteOffsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @storage = storages(:masters)
      @waybill = Waybill.create! kind: :write_off, storage: @storage, sender: users(:daniyar)
      sign_in :daniyar
    end

    test "should get new" do
      get new_waybills_write_off_url
      assert_response :success
    end

    test "should create write_off" do
      assert_difference("Waybill.count") do
        post waybills_write_offs_url, params: { waybill: { storage_id: @storage.id } }
      end

      assert_redirected_to edit_waybills_write_off_url(Waybill.last)
    end

    test "should show write_off" do
      get waybills_write_off_url(@waybill)
      assert_response :success
    end

    test "should get edit" do
      get edit_waybills_write_off_url(@waybill)
      assert_response :success
    end

    test "should update write_off" do
      patch waybills_write_off_url(@waybill), params: { waybill: { status: :approved } }
      assert_redirected_to waybills_write_off_url(@waybill)
    end

    test "should destroy write_off" do
      assert_difference("Waybill.count", -1) do
        delete waybills_write_off_url(@waybill)
      end

      assert_redirected_to journals_outgoings_url
    end
  end
end
