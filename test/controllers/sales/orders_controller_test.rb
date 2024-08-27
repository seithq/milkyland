require "test_helper"

class Sales::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:opening)
    @channel = @order.sales_channel
  end

  test "should get index" do
    sign_in :daniyar
    get sales_channel_orders_url(@channel)
    assert_response :success
  end

  test "should get new" do
    sign_in :daniyar
    get new_sales_channel_order_url(@channel)
    assert_response :success
  end

  test "should create order" do
    sign_in :daniyar
    assert_difference("Order.count") do
      post sales_channel_orders_url(@channel), params: { order: { client_id: @order.client_id, kind: @order.kind, preferred_date: @order.preferred_date, sales_point_id: @order.sales_point_id } }
    end

    assert_redirected_to edit_sales_channel_order_url(@channel, Order.last)
  end

  test "should show order" do
    sign_in :daniyar
    get sales_channel_order_url(@channel, @order)
    assert_response :success
  end

  test "should get edit" do
    sign_in :daniyar
    get edit_sales_channel_order_url(@channel, @order)
    assert_response :success
  end

  test "should update order" do
    sign_in :daniyar
    patch sales_channel_order_url(@channel, @order), params: { order: { preferred_date: 7.days.from_now } }
    assert_redirected_to sales_channel_orders_url(@channel)
  end

  test "should destroy order" do
    sign_in :daniyar
    assert_difference("Order.active.count", -1) do
      delete sales_channel_order_url(@channel, @order)
    end

    assert_redirected_to sales_channel_orders_url(@channel)
  end
end
