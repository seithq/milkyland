require "test_helper"

class Procurements::SupplyOrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @supply_order = supply_orders(:sugar_order)
    sign_in :daniyar
  end

  test "should get index" do
    get supply_orders_url
    assert_response :success
  end

  test "should get new" do
    get new_supply_order_url
    assert_response :success
  end

  test "should create supply_order" do
    assert_difference("SupplyOrder.count") do
      assert_enqueued_jobs 1, only: GenerateTransactionForSupplyOrderJob do
        post supply_orders_url, params: { supply_order: { amount: 1000, material_asset_id: @supply_order.material_asset_id, vendor_id: vendors(:sugar).id, payment_date: 1.week.from_now } }
      end
    end

    assert_redirected_to supply_orders_url
  end

  test "should show supply_order" do
    get supply_order_url(@supply_order)
    assert_response :success
  end

  test "should get edit" do
    get edit_supply_order_url(@supply_order)
    assert_response :success
  end

  test "should update supply_order" do
    patch supply_order_url(@supply_order), params: { supply_order: { delivery_status: :delivered, payment_status: :paid } }
    assert_redirected_to supply_orders_url
  end
end
