require "application_system_test_case"

module Warehouse::Storages::Zones
  class Lines::StacksTest < ApplicationSystemTestCase
    setup do
      @storage = storages(:goods)
      @zone = zones(:goods_zone)
      @line = lines(:goods_zone_line)
      @stack = @line.stacks.first
      sign_in "daniyar@hey.com"
    end

    test "should create stack" do
      visit edit_storage_zone_line_url(@storage, @zone, @line)
      find(".new_stack").click

      fill_in "stack_repeat", with: 1
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Stack" do
      visit edit_storage_zone_line_url(@storage, @zone, @line)
      find(".edit_stack", match: :first).click

      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Stack" do
      visit edit_storage_zone_line_url(@storage, @zone, @line)

      accept_alert do
        find(".destroy_stack", match: :first).click
      end

      assert_no_text I18n.t("actions.destroy_record")
    end
  end
end
