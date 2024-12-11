require "test_helper"

module Settings
  class MaterialAssets::VendorsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @vendor = vendors(:sugar)
      @material_asset = @vendor.material_asset
      sign_in :daniyar
    end

    test "should get index" do
      get material_asset_vendors_url(@material_asset)
      assert_response :success
    end

    test "should get new" do
      get new_material_asset_vendor_url(@material_asset)
      assert_response :success
    end

    test "should create vendor" do
      assert_difference("Vendor.count") do
        post material_asset_vendors_url(@material_asset), params: { vendor: { supplier_id: suppliers(:regata).id, entry_price: 100.0, delivery_time_in_days: 5 } }
      end

      assert_redirected_to edit_material_asset_url(@material_asset)
    end

    test "should get edit" do
      get edit_material_asset_vendor_url(@material_asset, @vendor)
      assert_response :success
    end

    test "should update vendor" do
      patch material_asset_vendor_url(@material_asset, @vendor), params: { vendor: { entry_price: 200.0 } }
      assert_redirected_to edit_material_asset_url(@material_asset)
    end

    test "should destroy vendor" do
      assert_difference("Vendor.active.count", -1) do
        delete material_asset_vendor_url(@material_asset, @vendor)
      end

      assert_redirected_to edit_material_asset_url(@material_asset)
    end
  end
end
