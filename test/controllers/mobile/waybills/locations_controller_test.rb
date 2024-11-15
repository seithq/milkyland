require "test_helper"

module Mobile
  class Waybills::LocationsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @zone = zones(:goods_zone)
      @pallet = Pallet.create
      sign_in :daniyar
    end

    test "should get new" do
      get new_waybills_location_url
      assert_response :success
    end

    test "should create location" do
      assert_difference("Location.count") do
        post waybills_locations_url, params: { location: { positionable_code: @zone.code, storable_codes: [ @pallet.code ] } }
      end

      assert_redirected_to feed_url
    end

    test "should not create location" do
      assert_difference("Location.count", 0) do
        post waybills_locations_url, params: { location: { positionable_code: @pallet.code, storable_codes: [ @pallet.code ] } }
      end

      assert_response :unprocessable_entity
    end
  end
end
