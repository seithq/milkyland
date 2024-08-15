require "application_system_test_case"

module Settings
  class Groups::JournalsTest < ApplicationSystemTestCase
    setup do
      @group = groups(:milk25)
      sign_in "daniyar@hey.com"
    end

    test "should create journal" do
      visit edit_group_path(@group)
      find(".new_journal").click

      fill_in "journal_name", with: "Cleaning"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Journal" do
      visit edit_group_path(@group)
      find(".edit_journal", match: :first).click

      fill_in "journal_name", with: "Cleaning"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Journal" do
      visit edit_group_path(@group)
      accept_alert do
        find(".destroy_journal", match: :first).click
      end

      assert_text I18n.t("actions.record_deleted")
    end
  end
end
