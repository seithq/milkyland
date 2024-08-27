require "application_system_test_case"

module Sales
  class Orders::PositionsTest < ApplicationSystemTestCase
    setup do
      @order = orders(:opening)
      @channel = @order.sales_channel
      sign_in "daniyar@hey.com"
    end

    test "should create position" do
      visit edit_sales_channel_order_url(@channel, @order)
      find(".new_position").click

      select products(:milk25_big).name, from: "position_product_id"
      fill_in "position_count", with: "1"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Position" do
      visit edit_sales_channel_order_url(@channel, @order)
      find(".edit_position", match: :first).click

      fill_in "position_count", with: "2"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Position" do
      visit edit_sales_channel_order_url(@channel, @order)
      find(".destroy_position", match: :first).click

      assert_text I18n.t("actions.record_deleted")
    end
  end
end
