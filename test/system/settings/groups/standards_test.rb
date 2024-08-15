require "application_system_test_case"

module Settings
  class Groups::StandardsTest < ApplicationSystemTestCase
    setup do
      @group = groups(:milk25)
      sign_in "daniyar@hey.com"
    end

    test "should create standard" do
      visit edit_group_path(@group)
      find(".new_standard").click

      select measurements(:kilogram).display_label, from: "standard_measurement_id"
      fill_in "standard_name", with: "GOST"
      fill_in "standard_from", with: "10"
      fill_in "standard_to", with: "100"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Standard" do
      visit edit_group_path(@group)
      find(".edit_standard", match: :first).click

      fill_in "standard_name", with: "GOST"
      fill_in "standard_from", with: "10"
      fill_in "standard_to", with: "100"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Standard" do
      visit edit_group_path(@group)

      accept_alert do
        find(".destroy_standard", match: :first).click
      end

      assert_text I18n.t("actions.record_deleted")
    end
  end
end
