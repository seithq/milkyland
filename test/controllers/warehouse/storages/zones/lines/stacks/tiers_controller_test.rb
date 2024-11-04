require "test_helper"

module Warehouse::Storages::Zones::Lines
  class Stacks::TiersControllerTest < ActionDispatch::IntegrationTest
    setup do
      @storage = storages(:goods)
      @zone = zones(:goods_zone)
      @line = lines(:goods_zone_line)
      @stack = stacks(:goods_zone_line_stack)
      @tier = @stack.tiers.first
      sign_in :daniyar
    end

    test "should get index" do
      get storage_zone_line_stack_tiers_url(@storage, @zone, @line, @stack)
      assert_response :success
    end

    test "should get new" do
      get new_storage_zone_line_stack_tier_url(@storage, @zone, @line, @stack)
      assert_response :success
    end

    test "should create tier" do
      assert_difference("Tier.count", 2) do
        post storage_zone_line_stack_tiers_url(@storage, @zone, @line, @stack), params: { tier: { active: true, repeat: 2 } }
      end

      assert_redirected_to edit_storage_zone_line_stack_url(@storage, @zone, @line, @stack)
    end

    test "should show tier" do
      get storage_zone_line_stack_tier_url(@storage, @zone, @line, @stack, @tier)
      assert_response :success
    end

    test "should get edit" do
      get edit_storage_zone_line_stack_tier_url(@storage, @zone, @line, @stack, @tier)
      assert_response :success
    end

    test "should update tier" do
      patch storage_zone_line_stack_tier_url(@storage, @zone, @line, @stack, @tier), params: { tier: { active: true } }
      assert_redirected_to edit_storage_zone_line_stack_url(@storage, @zone, @line, @stack)
    end

    test "should destroy tier" do
      assert_difference("Tier.active.count", -1) do
        delete storage_zone_line_stack_tier_url(@storage, @zone, @line, @stack, @tier)
      end

      assert_redirected_to storage_zone_line_stack_tiers_url(@storage, @zone, @line, @stack)
    end
  end
end
