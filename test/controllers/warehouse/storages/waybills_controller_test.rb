require "test_helper"

module Warehouse
  class Storages::WaybillsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @storage = storages(:material_assets)
      sign_in :daniyar
    end

    test "should get index" do
      get storage_waybills_url(@storage)
      assert_response :success
    end
  end
end
