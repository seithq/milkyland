require "test_helper"

module Warehouse
  class Storages::SubjectsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @material_assets_storage = storages(:material_assets)
      @products_storage = storages(:masters)
      sign_in :daniyar
    end

    test "should get index for material assets" do
      get storage_subjects_url(@material_assets_storage)
      assert_response :success
    end

    test "should get index for products" do
      get storage_subjects_url(@products_storage)
      assert_response :success
    end
  end
end
