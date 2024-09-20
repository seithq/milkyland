require "test_helper"

module Settings
  class Products::BoxPackagingsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @box_packaging = box_packagings(:bottle_milk25)
      @product = @box_packaging.product
    end

    test "should get index" do
      sign_in :daniyar
      get product_box_packagings_url(@product)
      assert_response :success
    end

    test "should get new" do
      sign_in :daniyar
      get new_product_box_packaging_url(@product)
      assert_response :success
    end

    test "should create box_packaging" do
      sign_in :daniyar
      assert_difference("BoxPackaging.count") do
        post product_box_packagings_url(@product), params: { box_packaging: { count: 3, material_asset_id: material_assets(:mini_bottle).id } }
      end

      assert_redirected_to edit_product_url(@product)
    end

    test "create does not allow non-admins to create record" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      post product_box_packagings_url(@product), params: { box_packaging: { count: 3, material_asset_id: material_assets(:mini_bottle).id } }
      assert_response :forbidden
    end

    test "should get edit" do
      sign_in :daniyar
      get edit_product_box_packaging_url(@product, @box_packaging)
      assert_response :success
    end

    test "should update box_packaging" do
      sign_in :daniyar
      patch product_box_packaging_url(@product, @box_packaging), params: { box_packaging: { count: 3, material_asset_id: material_assets(:mini_bottle).id } }
      assert_redirected_to edit_product_url(@product)
    end

    test "update does not allow non-admins to change roles" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      patch product_box_packaging_url(@product, @box_packaging), params: { box_packaging: { count: 3, material_asset_id: material_assets(:mini_bottle).id } }
      assert_response :forbidden
    end

    test "should destroy box_packaging" do
      sign_in :daniyar
      assert_difference("BoxPackaging.active.count", -1) do
        delete product_box_packaging_url(@product, @box_packaging)
      end

      assert_redirected_to edit_product_url(@product)
    end
  end
end