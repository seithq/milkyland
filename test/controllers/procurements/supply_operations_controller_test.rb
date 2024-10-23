require "test_helper"

class Procurements::SupplyOperationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @waybill = waybills(:assets_arrival)
    sign_in :daniyar
  end

  test "should get index" do
    get supply_operations_url
    assert_response :success
  end

  test "should get new" do
    get new_supply_operation_url
    assert_response :success
  end

  test "should create waybill" do
    assert_difference("Waybill.count") do
      post supply_operations_url, params: { waybill: { kind: :arrival, new_storage_id: storages(:material_assets).id, sender_id: users(:daniyar).id } }
    end

    assert_redirected_to edit_supply_operation_url(Waybill.last)
  end

  test "should show waybill" do
    get supply_operation_url(@waybill)
    assert_response :success
  end

  test "should get edit" do
    get edit_supply_operation_url(@waybill)
    assert_response :success
  end

  test "should update waybill" do
    patch supply_operation_url(@waybill), params: { waybill: { comment: "TEST" } }
    assert_redirected_to supply_operations_url
  end

  test "should destroy waybill" do
    assert_difference("Waybill.active.count", -1) do
      delete supply_operation_url(@waybill)
    end

    assert_redirected_to supply_operations_url
  end
end
