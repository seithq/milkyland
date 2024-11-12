require "test_helper"

module Warehouse
  class Storages::WarehousersControllerTest < ActionDispatch::IntegrationTest
    setup do
      @warehouser = warehousers(:goods_warehouser)
      @storage = @warehouser.storage
      sign_in :daniyar
    end

    test "should get index" do
      get storage_warehousers_url(@storage)
      assert_response :success
    end

    test "should get new" do
      get new_storage_warehouser_url(@storage)
      assert_response :success
    end

    test "should create warehouser" do
      assert_difference("Warehouser.count") do
        post storage_warehousers_url(@storage), params: { warehouser: { user_id: users(:daniyar).id } }
      end

      assert_redirected_to edit_storage_url(@storage)
    end

    test "should get edit" do
      get edit_storage_warehouser_url(@storage, @warehouser)
      assert_response :success
    end

    test "should update warehouser" do
      patch storage_warehouser_url(@storage, @warehouser), params: { warehouser: { active: true } }
      assert_redirected_to edit_storage_url(@storage)
    end

    test "should destroy warehouser" do
      assert_difference("Warehouser.active.count", -1) do
        delete storage_warehouser_url(@storage, @warehouser)
      end

      assert_redirected_to edit_storage_url(@storage)
    end
  end
end
