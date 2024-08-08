require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "create" do
    sign_in :daniyar
    assert users(:daniyar).admin?

    assert_difference("User.count", +1) do
      post users_url, params: { user: { name: "Test User", email_address: "test@example.com", password: "Secret1234", role: "member" } }
    end

    assert_redirected_to users_url
  end

  test "create does not allow non-admins to create record" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    post users_url, params: { user: { name: "Test User", email_address: "test@example.com", password: "Secret1234", role: "member" } }

    assert_response :forbidden
    assert_not users(:askhat).reload.admin?
  end

  test "update" do
    sign_in :daniyar
    assert users(:daniyar).admin?

    put user_url(users(:askhat)), params: { user: { role: "admin" } }

    assert_redirected_to users_url
    assert users(:askhat).reload.admin?
  end

  test "update does not allow non-admins to change roles" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    put user_url(users(:askhat)), params: { user: { role: "admin" } }

    assert_response :forbidden
    assert_not users(:askhat).reload.admin?
  end

  test "destroy" do
    sign_in :daniyar

    assert_difference -> { User.active.count }, -1 do
      delete user_url(users(:askhat))
    end

    assert_redirected_to users_url
    assert_nil User.active.find_by(id: users(:askhat).id)
  end

  test "destroy is not allowed to non-admins" do
    sign_in :askhat

    delete user_url(users(:daniyar))
    assert_response :forbidden
  end
end
