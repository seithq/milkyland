require "test_helper"

module Warehouse::Storages
  class Zones::LinesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @storage = storages(:goods)
      @zone = zones(:goods_zone)
      @line = @zone.lines.first
      sign_in :daniyar
    end

    test "should get index" do
      get storage_zone_lines_url(@storage, @zone)
      assert_response :success
    end

    test "should get new" do
      get new_storage_zone_line_url(@storage, @zone)
      assert_response :success
    end

    test "should create line" do
      assert_difference("Line.count", 2) do
        post storage_zone_lines_url(@storage, @zone), params: { line: { active: true, repeat: 2 } }
      end

      assert_redirected_to edit_storage_zone_url(@storage, @zone)
    end

    test "should show line" do
      get storage_zone_line_url(@storage, @zone, @line)
      assert_response :success
    end

    test "should get edit" do
      get edit_storage_zone_line_url(@storage, @zone, @line)
      assert_response :success
    end

    test "should update line" do
      patch storage_zone_line_url(@storage, @zone, @line), params: { line: { active: true } }
      assert_redirected_to edit_storage_zone_url(@storage, @zone)
    end

    test "should destroy line" do
      assert_difference("Line.active.count", -1) do
        delete storage_zone_line_url(@storage, @zone, @line)
      end

      assert_redirected_to storage_zone_lines_url(@storage, @zone)
    end
  end
end
