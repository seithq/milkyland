require "application_system_test_case"

module Logistics
  class Returns::ReturnedProductsTest < ApplicationSystemTestCase
    setup do
      create_return_for_departure
      sign_in "daniyar@hey.com"
    end

    test "should create returned product" do
      @returned_product.destroy

      visit edit_return_url(@return)
      find(".new_returned_product").click

      select products(:milk25).name_with_article, from: "returned_product_product_id"
      fill_in "returned_product_count", with: 2
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Returned product" do
      visit edit_return_url(@return)
      find(".edit_returned_product", match: :first).click

      fill_in "returned_product_count", with: 1
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Returned product" do
      visit edit_return_url(@return)

      accept_alert do
        find(".destroy_returned_product", match: :first).click
      end

      assert_no_text @returned_product.product.name
    end

    private
      def create_return_for_departure
        @waybill = Waybill.new kind: :departure,
                               status: :approved,
                               order: orders(:opening),
                               storage: storages(:goods),
                               sender: users(:daniyar)
        assert @waybill.save
        assert @waybill.leftovers.create subject: products(:milk25), count: 6

        @return = Return.new user: users(:daniyar),
                             order: orders(:opening),
                             storage: storages(:goods)
        assert @return.save

        @returned_product = @return.returned_products.new product: products(:milk25), count: 2
        assert @returned_product.save
      end
  end
end
