require "test_helper"

module Warehouse::Storages::Zones
  class Lines::StacksControllerTest < ActionDispatch::IntegrationTest
    setup do
      @storage = storages(:goods)
      @zone = zones(:goods_zone)
      @line = lines(:goods_zone_line)
      @stack = @line.stacks.first
      sign_in :daniyar
    end

    test "should get index" do
      get storage_zone_line_stacks_url(@storage, @zone, @line)
      assert_response :success
    end

    test "should get new" do
      get new_storage_zone_line_stack_url(@storage, @zone, @line)
      assert_response :success
    end

    test "should create stack" do
      assert_difference("Stack.count", 2) do
        post storage_zone_line_stacks_url(@storage, @zone, @line), params: { stack: { active: true, repeat: 2 } }
      end

      assert_redirected_to edit_storage_zone_line_url(@storage, @zone, @line)
    end

    test "should show stack" do
      get storage_zone_line_stack_url(@storage, @zone, @line, @stack)
      assert_response :success
    end

    test "should get edit" do
      get edit_storage_zone_line_stack_url(@storage, @zone, @line, @stack)
      assert_response :success
    end

    test "should update stack" do
      patch storage_zone_line_stack_url(@storage, @zone, @line, @stack), params: { stack: { active: true } }
      assert_redirected_to edit_storage_zone_line_url(@storage, @zone, @line)
    end

    test "should destroy stack" do
      assert_difference("Stack.active.count", -1) do
        delete storage_zone_line_stack_url(@storage, @zone, @line, @stack)
      end

      assert_redirected_to storage_zone_line_stacks_url(@storage, @zone, @line)
    end
  end
end
