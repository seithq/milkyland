require "application_system_test_case"

class Sales::OrdersTest < ApplicationSystemTestCase
  setup do
    @order = orders(:opening)
    @channel = @order.sales_channel
    sign_in "daniyar@hey.com"
  end

  test "visiting the index" do
    visit sales_channel_orders_url(@channel)
    assert_selector ".breadcrumb-link", text: I18n.t("pages.orders_by_channel", channel: @channel.name)
  end

  test "should create order" do
    visit sales_channel_orders_url(@channel)
    click_on I18n.t("actions.create_record")

    choose "order_kind_planned"
    select clients(:systemd).name, from: "order_client_id"
    select sales_points(:seit).name, from: "order_sales_point_id"
    fill_in "order_preferred_date", with: 7.days.from_now
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
  end

  test "should update Order" do
    visit sales_channel_orders_url(@channel)
    click_on I18n.t("actions.edit_record"), match: :first

    fill_in "order_preferred_date", with: 10.days.from_now
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_updated")
  end

  test "should destroy Order" do
    visit edit_sales_channel_order_url(@channel, @order)

    accept_alert do
      find(".destroy_order", match: :first).click
    end

    assert_text I18n.t("actions.order_cancelled")
  end
end
