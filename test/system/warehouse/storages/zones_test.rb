require "application_system_test_case"

module Warehouse
  class Storages::ZonesTest < ApplicationSystemTestCase
    setup do
      @storage = storages(:goods)
      @zone = @storage.zones.first
      sign_in "daniyar@hey.com"
    end

    test "should create zone" do
      visit edit_storage_url(@storage)
      find(".new_zone").click

      select Zone.enum_to_s(:kind, :ship), from: "zone_kind"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Zone" do
      visit edit_storage_url(@storage)
      find(".edit_zone", match: :first).click

      select Zone.enum_to_s(:kind, :hold), from: "zone_kind"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Zone" do
      visit edit_storage_url(@storage)

      accept_alert do
        find(".destroy_zone", match: :first).click
      end

      assert_no_text I18n.t("actions.destroy_record")
    end
  end
end
