require "application_system_test_case"

module Settings
  class Groups::OperationsTest < ApplicationSystemTestCase
    setup do
      @group = groups(:milk25)
      sign_in "daniyar@hey.com"
    end

    test "should create operation" do
      visit edit_group_path(@group)
      find(".new_operation").click

      select journals(:skimming).name, from: "operation_journal_id"
      fill_in "operation_name", with: "Final Probe"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Operation" do
      visit edit_group_path(@group)
      find(".edit_operation", match: :first).click

      fill_in "operation_name", with: "Final Probe"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Operation" do
      visit edit_group_path(@group)
      accept_alert do
        find(".destroy_operation", match: :first).click
      end

      assert_text I18n.t("actions.record_deleted")
    end
  end
end
