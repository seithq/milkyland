require "test_helper"

module Settings
  class Groups::OperationsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @operation = operations(:analysis)
      @group = @operation.journal.group
    end

    test "should get index" do
      sign_in :daniyar
      get group_operations_url(@group)
      assert_response :success
    end

    test "should get new" do
      sign_in :daniyar
      get new_group_operation_url(@group)
      assert_response :success
    end

    test "should create operation" do
      sign_in :daniyar
      assert_difference("Operation.count") do
        post group_operations_url(@group), params: { operation: { journal_id: @operation.journal_id, name: "New Operation", chain_order: 1 } }
      end

      assert_redirected_to edit_group_path(@group)
    end

    test "create does not allow non-admins to create record" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      post group_operations_url(@group), params: { operation: { journal_id: @operation.journal_id, name: "New Operation", chain_order: 1 } }
      assert_response :forbidden
    end

    test "should get edit" do
      sign_in :daniyar
      get edit_group_operation_url(@group, @operation)
      assert_response :success
    end

    test "should update operation" do
      sign_in :daniyar
      patch group_operation_url(@group, @operation), params: { operation: { name: "New Name", chain_order: 1 } }
      assert_redirected_to edit_group_path(@group)
    end

    test "update does not allow non-admins to change roles" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      patch group_operation_url(@group, @operation), params: { operation: { name: "New Name", chain_order: 1 } }
      assert_response :forbidden
    end

    test "should destroy operation" do
      sign_in :daniyar
      assert_difference("Operation.active.count", -1) do
        delete group_operation_url(@group, @operation)
      end

      assert_redirected_to edit_group_path(@group)
    end
  end
end
