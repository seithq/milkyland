require "application_system_test_case"

module Warehouse::Storages
  class Zones::LinesTest < ApplicationSystemTestCase
    setup do
      @storage = storages(:goods)
      @zone = zones(:goods_zone)
      @line = @zone.lines.first
      sign_in "daniyar@hey.com"
    end

    test "should create line" do
      visit edit_storage_zone_url(@storage, @zone)
      find(".new_line").click

      fill_in "line_repeat", with: 1
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Line" do
      visit edit_storage_zone_url(@storage, @zone)
      find(".edit_line", match: :first).click

      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Line" do
      visit edit_storage_zone_url(@storage, @zone)

      accept_alert do
        find(".destroy_line", match: :first).click
      end

      assert_no_text I18n.t("actions.destroy_record")
    end
  end
end
