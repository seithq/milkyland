require "test_helper"

class Settings::MaterialAssetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @material_asset = material_assets(:sugar)
  end

  test "should get index" do
    sign_in :daniyar
    get material_assets_url
    assert_response :success
  end

  test "should get new" do
    sign_in :daniyar
    get new_material_asset_url
    assert_response :success
  end

  test "should create material_asset" do
    sign_in :daniyar
    assert_difference("MaterialAsset.count") do
      post material_assets_url, params: {
        material_asset: { name: "XPL-20",
                          article: "1234567",
                          packing: 1000,
                          category_id: @material_asset.category_id,
                          measurement_id: @material_asset.measurement_id
        }
      }
    end

    assert_redirected_to material_assets_url
  end

  test "should show material_asset" do
    sign_in :daniyar
    get material_asset_url(@material_asset)
    assert_response :success
  end

  test "should get edit" do
    sign_in :daniyar
    get edit_material_asset_url(@material_asset)
    assert_response :success
  end

  test "should update material_asset" do
    sign_in :daniyar
    patch material_asset_url(@material_asset), params: { material_asset: { name: "XPL-30" } }
    assert_redirected_to material_assets_url
  end
end
