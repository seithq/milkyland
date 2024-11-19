require "test_helper"

module Mobile
  class Waybills::ArrivalsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @storage = storages(:masters)
      @waybill = Waybill.create! kind: :arrival, new_storage: @storage, sender: users(:daniyar)
      sign_in :daniyar
    end

    test "should get new" do
      get new_waybills_arrival_url
      assert_response :success
    end

    test "should create arrival" do
      assert_difference("Waybill.count") do
        post waybills_arrivals_url, params: { waybill: { new_storage_id: storages(:masters).id } }
      end

      assert_redirected_to edit_waybills_arrival_url(Waybill.last)
    end

    test "should show arrival" do
      get waybills_arrival_url(@waybill)
      assert_response :success
    end

    test "should get edit" do
      get edit_waybills_arrival_url(@waybill)
      assert_response :success
    end

    test "should update arrival" do
      patch waybills_arrival_url(@waybill), params: { waybill: { status: :approved } }
      assert_redirected_to waybills_arrival_url(@waybill)
    end

    test "should destroy arrival" do
      assert_difference("Waybill.count", -1) do
        delete waybills_arrival_url(@waybill)
      end

      assert_redirected_to journals_outgoings_url
    end
  end
end
