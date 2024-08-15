require "application_system_test_case"

module Settings
  class Groups::IngredientsTest < ApplicationSystemTestCase
    setup do
      @group = groups(:milk25)
      sign_in "daniyar@hey.com"
    end

    test "should create ingredient" do
      visit edit_group_path(@group)
      click_on I18n.t("actions.create_record")

      select material_assets(:water).display_label, from: "ingredient_material_asset_id"
      fill_in "ingredient_ratio", with: "100"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Ingredient" do
      visit edit_group_path(@group)
      click_on I18n.t("actions.edit_record"), match: :first

      fill_in "ingredient_ratio", with: "100"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Ingredient" do
      visit edit_group_path(@group)

      accept_alert do
        click_on I18n.t("actions.destroy_record"), match: :first
      end

      assert_text I18n.t("actions.record_deleted")
    end
  end
end
