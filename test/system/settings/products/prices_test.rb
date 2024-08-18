require "application_system_test_case"

module Settings
  class Products::PricesTest < ApplicationSystemTestCase
    setup do
      @product = products(:milk25)
      sign_in "daniyar@hey.com"
    end

    test "should create price" do
      channel = SalesChannel.create!(name: "Test")

      visit edit_product_url(@product)
      find(".new_price").click

      select channel.name, from: "price_sales_channel_id"
      fill_in "price_value", with: "1000"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Price" do
      visit edit_product_url(@product)
      find(".edit_price", match: :first).click

      fill_in "price_value", with: "1000"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Price" do
      visit edit_product_url(@product)

      accept_alert do
        find(".destroy_price", match: :first).click
      end

      assert_text I18n.t("actions.record_deleted")
    end
  end
end
