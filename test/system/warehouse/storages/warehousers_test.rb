require "application_system_test_case"

module Warehouse
  class Storages::WarehousersTest < ApplicationSystemTestCase
    setup do
      @warehouser = warehousers(:goods_warehouser)
      @storage = @warehouser.storage
      sign_in "daniyar@hey.com"
    end

    test "should create warehouser" do
      visit edit_storage_url(storages(:masters))
      find(".new_warehouser").click

      select users(:warehouser).name, from: "warehouser_user_id"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Warehouser" do
      visit edit_storage_url(@storage)
      find(".edit_warehouser", match: :first).click

      select users(:warehouser).name, from: "warehouser_user_id"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Warehouser" do
      visit edit_storage_url(@storage)

      accept_alert do
        find(".destroy_warehouser", match: :first).click
      end

      assert_text I18n.t("actions.record_deactivated")
    end
  end
end
