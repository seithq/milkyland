require "test_helper"

class BoxPackagingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @box_packaging = box_packagings(:one)
  end

  test "should get index" do
    get box_packagings_url
    assert_response :success
  end

  test "should get new" do
    get new_box_packaging_url
    assert_response :success
  end

  test "should create box_packaging" do
    assert_difference("BoxPackaging.count") do
      post box_packagings_url, params: { box_packaging: { count: @box_packaging.count, material_asset_id: @box_packaging.material_asset_id, product_id: @box_packaging.product_id } }
    end

    assert_redirected_to box_packaging_url(BoxPackaging.last)
  end

  test "should show box_packaging" do
    get box_packaging_url(@box_packaging)
    assert_response :success
  end

  test "should get edit" do
    get edit_box_packaging_url(@box_packaging)
    assert_response :success
  end

  test "should update box_packaging" do
    patch box_packaging_url(@box_packaging), params: { box_packaging: { count: @box_packaging.count, material_asset_id: @box_packaging.material_asset_id, product_id: @box_packaging.product_id } }
    assert_redirected_to box_packaging_url(@box_packaging)
  end

  test "should destroy box_packaging" do
    assert_difference("BoxPackaging.count", -1) do
      delete box_packaging_url(@box_packaging)
    end

    assert_redirected_to box_packagings_url
  end
end
