require "test_helper"

module Settings
  class Groups::FieldsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @field = fields(:start_time)
      @group = @field.operation.journal.group
    end

    test "should get index" do
      sign_in :daniyar
      get group_fields_url(@group)
      assert_response :success
    end

    test "should get new" do
      sign_in :daniyar
      get new_group_field_url(@group)
      assert_response :success
    end

    test "should create field" do
      sign_in :daniyar
      assert_difference("Field.count") do
        post group_fields_url(@group), params: { field: { kind: "time", name: "End Time", chain_order: 1, operation_id: @field.operation_id } }
      end

      assert_redirected_to edit_group_path(@group)
    end

    test "create does not allow non-admins to create record" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      post group_fields_url(@group), params: { field: { kind: "time", name: "End Time", chain_order: 1, operation_id: @field.operation_id } }
      assert_response :forbidden
    end

    test "should get edit" do
      sign_in :daniyar
      get edit_group_field_url(@group, @field)
      assert_response :success
    end

    test "should update field" do
      sign_in :daniyar
      patch group_field_url(@group, @field), params: { field: { name: "Mid Time" } }
      assert_redirected_to edit_group_path(@group)
    end

    test "update does not allow non-admins to change roles" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      patch group_field_url(@group, @field), params: { field: { name: "Mid Time" } }
      assert_response :forbidden
    end

    test "should destroy field" do
      sign_in :daniyar
      assert_difference("Field.active.count", -1) do
        delete group_field_url(@group, @field)
      end

      assert_redirected_to edit_group_path(@group)
    end
  end
end
