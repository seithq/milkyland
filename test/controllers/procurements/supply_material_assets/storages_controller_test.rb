require "test_helper"

module Procurements
  class SupplyMaterialAssets::StoragesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @material_asset = material_assets(:sugar)
      sign_in :daniyar
    end

    test "should get index" do
      get supply_material_asset_storages_path(@material_asset)
      assert_response :success
    end
  end
end
