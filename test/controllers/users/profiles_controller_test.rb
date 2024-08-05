require "test_helper"

class Users::ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "show" do
    sign_in :daniyar

    get user_profile_url(users(:daniyar))
    assert_response :success

    get user_profile_url(users(:askhat))
    assert_response :success
  end

  test "edit is accessable to the current user" do
    sign_in :daniyar

    get edit_user_profile_url(users(:daniyar))
    assert_response :success

    get edit_user_profile_url(users(:askhat))
    assert_response :forbidden
  end

  test "update modifies profile for current user" do
    sign_in :askhat

    put user_profile_url(users(:askhat)), params: { user: { name: "Bob" } }

    assert_redirected_to root_url
    assert_equal "Bob", users(:askhat).reload.name
  end

  test "update prohibits modifying profile of other users" do
    sign_in :daniyar

    put user_profile_url(users(:askhat)), params: { user: { name: "Bob" } }

    assert_response :forbidden
    assert_equal "Askhat", users(:askhat).reload.name
  end
end
