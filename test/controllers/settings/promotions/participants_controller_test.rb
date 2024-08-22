require "test_helper"

module Settings
  class Promotions::ParticipantsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @participant = participants(:big_deal_systemd)
      @promotion = @participant.promotion
    end

    test "should get index" do
      sign_in :daniyar
      get promotion_participants_url(@promotion)
      assert_response :success
    end

    test "should get new" do
      sign_in :daniyar
      get new_promotion_participant_url(@promotion)
      assert_response :success
    end

    test "should create participant" do
      sign_in :daniyar
      client = Client.create!(name: "REGATA", bin: "921026400042", manager_id: users(:askhat).id)
      assert_difference("Participant.count") do
        post promotion_participants_url(@promotion), params: { participant: { client_id: client.id } }
      end

      assert_redirected_to edit_promotion_url(@promotion)
    end

    test "create does not allow non-admins to create record" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      client = Client.create!(name: "REGATA", bin: "921026400042", manager_id: users(:askhat).id)
      post promotion_participants_url(@promotion), params: { participant: { client_id: client.id } }
      assert_response :forbidden
    end

    test "should get edit" do
      sign_in :daniyar
      get edit_promotion_participant_url(@promotion, @participant)
      assert_response :success
    end

    test "should update participant" do
      sign_in :daniyar
      patch promotion_participant_url(@promotion, @participant), params: { participant: { active: true } }
      assert_redirected_to edit_promotion_url(@promotion)
    end

    test "update does not allow non-admins to change roles" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      patch promotion_participant_url(@promotion, @participant), params: { participant: { active: true } }
      assert_response :forbidden
    end

    test "should destroy participant" do
      sign_in :daniyar
      assert_difference("Participant.active.count", -1) do
        delete promotion_participant_url(@promotion, @participant)
      end

      assert_redirected_to edit_promotion_url(@promotion)
    end
  end
end
