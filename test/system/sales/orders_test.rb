require "application_system_test_case"

class Sales::OrdersTest < ApplicationSystemTestCase
  setup do
    @order = orders(:one)
  end

  test "visiting the index" do
    visit orders_url
    assert_selector "h1", text: "Orders"
  end

  test "should create order" do
    visit orders_url
    click_on "New order"

    fill_in "Client", with: @order.client_id
    fill_in "Kind", with: @order.kind
    fill_in "Preferred date", with: @order.preferred_date
    fill_in "Sales channel", with: @order.sales_channel_id
    fill_in "Sales point", with: @order.sales_point_id
    fill_in "Status", with: @order.status
    click_on "Create Order"

    assert_text "Order was successfully created"
    click_on "Back"
  end

  test "should update Order" do
    visit order_url(@order)
    click_on "Edit this order", match: :first

    fill_in "Client", with: @order.client_id
    fill_in "Kind", with: @order.kind
    fill_in "Preferred date", with: @order.preferred_date
    fill_in "Sales channel", with: @order.sales_channel_id
    fill_in "Sales point", with: @order.sales_point_id
    fill_in "Status", with: @order.status
    click_on "Update Order"

    assert_text "Order was successfully updated"
    click_on "Back"
  end

  test "should destroy Order" do
    visit order_url(@order)
    click_on "Destroy this order", match: :first

    assert_text "Order was successfully destroyed"
  end
end
