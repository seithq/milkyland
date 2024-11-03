require "test_helper"

module Warehouse
  class Storages::ZonesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @storage = storages(:goods)
      @zone = @storage.zones.first
      sign_in :daniyar
    end

    test "should get index" do
      get storage_zones_url(@storage)
      assert_response :success
    end

    test "should get new" do
      get new_storage_zone_url(@storage)
      assert_response :success
    end

    test "should create zone" do
      assert_difference("Zone.count") do
        post storage_zones_url(@storage), params: { zone: { kind: :ship } }
      end

      assert_redirected_to edit_storage_url(@storage)
    end

    test "should show zone" do
      get storage_zone_url(@storage, @zone)
      assert_response :success
    end

    test "should get edit" do
      get edit_storage_zone_url(@storage, @zone)
      assert_response :success
    end

    test "should update zone" do
      patch storage_zone_url(@storage, @zone), params: { zone: { kind: :hold, active: true } }
      assert_redirected_to edit_storage_url(@storage)
    end

    test "should destroy zone" do
      assert_difference("Zone.active.count", -1) do
        delete storage_zone_url(@storage, @zone)
      end

      assert_redirected_to storage_zones_url(@storage)
    end
  end
end
