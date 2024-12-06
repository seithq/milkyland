require "application_system_test_case"

module Settings
  class Products::CustomPricesTest < ApplicationSystemTestCase
    setup do
      @product = products(:milk25)
      sign_in "daniyar@hey.com"
    end

    test "should create custom price" do
      @product.custom_prices.destroy_all

      visit edit_product_url(@product)
      find(".new_custom_price").click

      select clients(:systemd).name, from: "custom_price_client_id"
      fill_in "custom_price_value", with: "1000"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Custom price" do
      visit edit_product_url(@product)
      find(".edit_custom_price", match: :first).click

      fill_in "custom_price_value", with: "1000"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Custom price" do
      visit edit_product_url(@product)

      accept_alert do
        find(".destroy_custom_price", match: :first).click
      end

      assert_text I18n.t("actions.record_deleted")
    end
  end
end
