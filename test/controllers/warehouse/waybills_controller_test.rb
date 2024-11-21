require "test_helper"

class Warehouse::WaybillsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @storage = storages(:masters)
    @waybill = Waybill.create! kind: :arrival, new_storage: @storage, sender: users(:daniyar)
    sign_in :daniyar
  end

  test "should get index" do
    get waybills_url
    assert_response :success
  end

  test "should show waybill" do
    get waybill_url(@waybill)
    assert_response :success
  end
end
