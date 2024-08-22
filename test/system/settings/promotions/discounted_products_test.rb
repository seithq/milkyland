require "application_system_test_case"

module Settings
  class Promotions::DiscountedProductsTest < ApplicationSystemTestCase
    setup do
      @promotion = promotions(:big_deal)
      sign_in "daniyar@hey.com"
    end

    test "should create discounted product" do
      visit edit_promotion_url(@promotion)
      find(".new_product").click

      select products(:milk25_big).name, from: "discounted_product_product_id"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Discounted product" do
      visit edit_promotion_url(@promotion)
      find(".edit_product", match: :first).click

      select products(:milk25_big).name, from: "discounted_product_product_id"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Discounted product" do
      visit edit_promotion_url(@promotion)

      accept_alert do
        find(".destroy_product", match: :first).click
      end

      assert_text I18n.t("actions.record_deleted")
    end
  end
end
