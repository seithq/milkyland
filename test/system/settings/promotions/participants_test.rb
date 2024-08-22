require "application_system_test_case"

module Settings
  class Promotions::ParticipantsTest < ApplicationSystemTestCase
    setup do
      @promotion = promotions(:big_deal)
      sign_in "daniyar@hey.com"
    end

    test "should create participant" do
      client = Client.create!(name: "REGATA", bin: "921026400042", manager_id: users(:askhat).id)

      visit edit_promotion_url(@promotion)
      find(".new_participant").click

      select client.name, from: "participant_client_id"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_created")
    end

    test "should update Participant" do
      visit edit_promotion_url(@promotion)
      find(".edit_participant", match: :first).click

      select clients(:systemd).name, from: "participant_client_id"
      click_on I18n.t("actions.save_record")

      assert_text I18n.t("actions.record_updated")
    end

    test "should destroy Participant" do
      visit edit_promotion_url(@promotion)

      accept_alert do
        find(".destroy_participant", match: :first).click
      end

      assert_text I18n.t("actions.record_deleted")
    end
  end
end
