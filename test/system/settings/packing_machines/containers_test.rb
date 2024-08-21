require "application_system_test_case"

module Settings
  class PackingMachines::ContainersTest < ApplicationSystemTestCase
    setup do
      @packing_machine = packing_machines(:bottler)
      sign_in "daniyar@hey.com"
    end

    test "should create container" do
      visit edit_packing_machine_url(@packing_machine)
      find(".new_container").click

      select material_assets(:mini_bottle).name, from: "container_material_asset_id"
      fill_in "container_losses_percentage", with: "2"
      fill_in "container_performance", with: "2000"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Container" do
      visit edit_packing_machine_url(@packing_machine)
      find(".edit_container", match: :first).click

      fill_in "container_losses_percentage", with: "2"
      fill_in "container_performance", with: "2000"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Container" do
      visit edit_packing_machine_url(@packing_machine)

      accept_alert do
        find(".destroy_container", match: :first).click
      end

      assert_text I18n.t("actions.record_deleted")
    end
  end
end
