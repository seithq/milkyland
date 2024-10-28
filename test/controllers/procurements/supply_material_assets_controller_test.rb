require "test_helper"

class Procurements::SupplyMaterialAssetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @material_asset = material_assets(:sugar)
    sign_in :daniyar
  end

  test "should get index" do
    get supply_material_assets_url
    assert_response :success
  end

  test "should show supply_material_asset" do
    get supply_material_asset_url(@material_asset)
    assert_response :success
  end
end
