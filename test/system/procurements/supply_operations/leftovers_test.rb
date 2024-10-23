require "application_system_test_case"

module Procurements
  class SupplyOperations::LeftoversTest < ApplicationSystemTestCase
    setup do
      @waybill = waybills(:assets_arrival)
      sign_in "daniyar@hey.com"
    end

    test "should create leftover" do
      visit edit_supply_operation_url(@waybill)
      find(".new_leftover").click

      select material_assets(:сardboard).display_label, from: "leftover_subject_id"
      fill_in "leftover_count", with: 1000
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Leftover" do
      visit edit_supply_operation_url(@waybill)
      find(".edit_leftover", match: :first).click

      fill_in "leftover_count", with: 7000
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Leftover" do
      visit edit_supply_operation_url(@waybill)

      accept_alert do
        find(".destroy_leftover", match: :first).click
      end
    end
  end
end
