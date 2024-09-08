require "application_system_test_case"

module Settings
  class Clients::SalesPointsTest < ApplicationSystemTestCase
    setup do
      @client = clients(:systemd)
      sign_in "daniyar@hey.com"
    end

    test "should create sales point" do
      visit edit_client_url(@client)
      find(".new_sales_point").click

      fill_in "sales_point_name", with: "New Store"
      select regions(:almaty).name, from: "sales_point_region_id"
      fill_in "sales_point_address", with: "New Address"
      fill_in "sales_point_phone_number", with: "+77772514515"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Sales point" do
      visit edit_client_url(@client)
      find(".edit_sales_point", match: :first).click

      fill_in "sales_point_address", with: "New Address"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Sales point" do
      visit edit_client_url(@client)

      accept_alert do
        find(".destroy_sales_point", match: :first).click
      end

      assert_text I18n.t("actions.record_deleted")
    end
  end
end
