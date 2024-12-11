require "application_system_test_case"

module Settings
  class MaterialAssets::VendorsTest < ApplicationSystemTestCase
    setup do
      @material_asset = material_assets(:sugar)
      sign_in "daniyar@hey.com"
    end

    test "should create vendor" do
      visit edit_material_asset_path(@material_asset)
      find(".new_vendor").click

      select suppliers(:regata).name, from: "vendor_supplier_id"
      fill_in "vendor_delivery_time_in_days", with: 5
      fill_in "vendor_entry_price", with: 100
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Vendor" do
      visit edit_material_asset_path(@material_asset)
      find(".edit_vendor", match: :first).click

      fill_in "vendor_entry_price", with: 200
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Vendor" do
      visit edit_material_asset_path(@material_asset)

      accept_alert do
        find(".destroy_vendor", match: :first).click
      end

      assert_text I18n.t("actions.record_deactivated")
    end
  end
end
