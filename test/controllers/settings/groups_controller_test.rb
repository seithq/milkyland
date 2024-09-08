require "test_helper"

class Settings::GroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group = groups(:milk25)
  end

  test "should get index" do
    sign_in :daniyar
    get groups_url
    assert_response :success
  end

  test "should get new" do
    sign_in :daniyar
    get new_group_url
    assert_response :success
  end

  test "should create group" do
    sign_in :daniyar
    assert_difference("Group.count") do
      post groups_url, params: { group: { name: "Milk 5%", metric_tonne: 1, category_id: categories(:milk).id } }
    end

    assert_redirected_to edit_group_url(Group.last)
  end

  test "create does not allow non-admins to create record" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    post groups_url, params: { group: { name: "Milk 5%", metric_tonne: 1, category_id: categories(:milk).id } }
    assert_response :forbidden
  end

  test "should show group" do
    sign_in :daniyar
    get group_url(@group)
    assert_response :success
  end

  test "should get edit" do
    sign_in :daniyar
    get edit_group_url(@group)
    assert_response :success
  end

  test "should update group" do
    sign_in :daniyar
    patch group_url(@group), params: { group: { name: "Milk 9%" } }
    assert_redirected_to groups_url
  end

  test "update does not allow non-admins to change roles" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    patch group_url(@group), params: { group: { name: "Milk 9%" } }
    assert_response :forbidden
  end
end
