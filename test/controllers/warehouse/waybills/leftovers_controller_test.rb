require "test_helper"

module Warehouse
  class Waybills::LeftoversControllerTest < ActionDispatch::IntegrationTest
    setup do
      @waybill = waybills(:assets_arrival)
      @leftover = @waybill.leftovers.last
      sign_in :daniyar
    end

    test "should get index" do
      get waybills_path(@waybill)
      assert_response :success
    end
  end
end
