require "application_system_test_case"

module Warehouse::Storages::Zones::Lines
  class Stacks::TiersTest < ApplicationSystemTestCase
    setup do
      @storage = storages(:goods)
      @zone = zones(:goods_zone)
      @line = lines(:goods_zone_line)
      @stack = stacks(:goods_zone_line_stack)
      @tier = @stack.tiers.first
      sign_in "daniyar@hey.com"
    end

    test "should create tier" do
      visit edit_storage_zone_line_stack_url(@storage, @zone, @line, @stack)
      find(".new_tier").click

      fill_in "tier_repeat", with: 1
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Tier" do
      visit edit_storage_zone_line_stack_url(@storage, @zone, @line, @stack)
      find(".edit_tier", match: :first).click

      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Tier" do
      visit edit_storage_zone_line_stack_url(@storage, @zone, @line, @stack)

      accept_alert do
        find(".destroy_tier", match: :first).click
      end

      assert_no_text I18n.t("actions.destroy_record")
    end
  end
end
