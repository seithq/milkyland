require "test_helper"

module Procurements
  class SupplyOperations::LeftoversControllerTest < ActionDispatch::IntegrationTest
    setup do
      @waybill = waybills(:assets_arrival)
      @leftover = @waybill.leftovers.last
      sign_in :daniyar
    end

    test "should get index" do
      get supply_operation_leftovers_url(@waybill)
      assert_response :success
    end

    test "should get new" do
      get new_supply_operation_leftover_url(@waybill)
      assert_response :success
    end

    test "should create leftover" do
      assert_difference("Leftover.count") do
        post supply_operation_leftovers_url(@waybill), params: { leftover: { count: 1000, subject_id: material_assets(:сardboard).id, subject_type: "MaterialAsset" } }
      end

      assert_redirected_to edit_supply_operation_path(@waybill)
    end

    test "should get edit" do
      get edit_supply_operation_leftover_url(@waybill, @leftover)
      assert_response :success
    end

    test "should update leftover" do
      patch supply_operation_leftover_url(@waybill, @leftover), params: { leftover: { count: 2000 } }
      assert_redirected_to edit_supply_operation_path(@waybill)
    end

    test "should destroy leftover" do
      assert_difference("Leftover.count", -1) do
        delete supply_operation_leftover_url(@waybill, @leftover)
      end

      assert_redirected_to edit_supply_operation_path(@waybill)
    end
  end
end
