require "test_helper"

module Settings
  class Groups::JournalsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @journal = journals(:skimming)
      @group = @journal.group
    end

    test "should get index" do
      sign_in :daniyar
      get group_journals_url(@group)
      assert_response :success
    end

    test "should get new" do
      sign_in :daniyar
      get new_group_journal_url(@group)
      assert_response :success
    end

    test "should create journal" do
      sign_in :daniyar
      assert_difference("Journal.count") do
        post group_journals_url(@group), params: { journal: { name: "Boiling" } }
      end

      assert_redirected_to edit_group_path(@group)
    end

    test "create does not allow non-admins to create record" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      post group_journals_url(@group), params: { journal: { name: "Boiling" } }
      assert_response :forbidden
    end

    test "should get edit" do
      sign_in :daniyar
      get edit_group_journal_url(@group, @journal)
      assert_response :success
    end

    test "should update journal" do
      sign_in :daniyar
      patch group_journal_url(@group, @journal), params: { journal: { name: "Cleaning" } }
      assert_redirected_to edit_group_path(@group)
    end

    test "update does not allow non-admins to change roles" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      patch group_journal_url(@group, @journal), params: { journal: { name: "Cleaning" } }
      assert_response :forbidden
    end

    test "should destroy journal" do
      sign_in :daniyar
      assert_difference("Journal.active.count", -1) do
        delete group_journal_url(@group, @journal)
      end

      assert_redirected_to edit_group_path(@group)
    end
  end
end
