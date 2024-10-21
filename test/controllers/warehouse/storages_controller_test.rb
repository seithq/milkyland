require "test_helper"

class Warehouse::StoragesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @storage = storages(:goods)
    sign_in :daniyar
  end

  test "should get index" do
    get storages_url
    assert_response :success
  end

  test "should get new" do
    get new_storage_url
    assert_response :success
  end

  test "should create storage" do
    assert_difference("Storage.count") do
      post storages_url, params: { storage: { kind: :for_goods, name: "New Storage" } }
    end

    assert_redirected_to storages_url
  end

  test "should show storage" do
    get storage_url(@storage)
    assert_response :success
  end

  test "should get edit" do
    get edit_storage_url(@storage)
    assert_response :success
  end

  test "should update storage" do
    patch storage_url(@storage), params: { storage: { kind: @storage.kind, name: "New Name" } }
    assert_redirected_to storages_url
  end
end
