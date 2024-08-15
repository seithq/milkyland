require "test_helper"

module Settings
  class Groups::StandardsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @standard = standards(:acidity)
      @group = @standard.group
    end

    test "should get index" do
      sign_in :daniyar
      get group_standards_url(@group)
      assert_response :success
    end

    test "should get new" do
      sign_in :daniyar
      get new_group_standard_url(@group)
      assert_response :success
    end

    test "should create standard" do
      sign_in :daniyar
      assert_difference("Standard.count") do
        post group_standards_url(@group), params: { standard: { name: "GOST", from: 10, to: 50, measurement_id: measurements(:kilogram).id } }
      end

      assert_redirected_to edit_group_path(@group)
    end

    test "create does not allow non-admins to create record" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      post group_standards_url(@group), params: { standard: { name: "GOST", from: 10, to: 50 } }
      assert_response :forbidden
    end

    test "should get edit" do
      sign_in :daniyar
      get edit_group_standard_url(@group, @standard)
      assert_response :success
    end

    test "should update standard" do
      sign_in :daniyar
      patch group_standard_url(@group, @standard), params: { standard: { name: "GOST", from: 10, to: 50 } }
      assert_redirected_to edit_group_path(@group)
    end

    test "update does not allow non-admins to change roles" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      patch group_standard_url(@group, @standard), params: { standard: { name: "GOST", from: 10, to: 50 } }
      assert_response :forbidden
    end

    test "should destroy standard" do
      sign_in :daniyar
      assert_difference("Standard.active.count", -1) do
        delete group_standard_url(@group, @standard)
      end

      assert_redirected_to edit_group_path(@group)
    end
  end
end
