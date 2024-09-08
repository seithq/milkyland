require "application_system_test_case"

module Settings
  class Groups::FieldsTest < ApplicationSystemTestCase
    setup do
      @group = groups(:milk25)
      sign_in "daniyar@hey.com"
    end

    test "should create field" do
      visit edit_group_path(@group)
      find(".new_field").click

      select operations(:analysis).name, from: "field_operation_id"
      select Field.enum_to_s(:kind, :time), from: "field_kind"
      fill_in "field_name", with: "Mid Time"
      fill_in "field_chain_order", with: "1"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Field" do
      visit edit_group_path(@group)
      find(".edit_field", match: :first).click

      fill_in "field_name", with: "Mid Time"
      fill_in "field_chain_order", with: "1"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Field" do
      visit edit_group_path(@group)
      accept_alert do
        find(".destroy_field", match: :first).click
      end

      assert_text I18n.t("actions.record_deleted")
    end
  end
end
