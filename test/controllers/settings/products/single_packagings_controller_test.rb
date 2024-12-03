require "test_helper"

module Settings
  class Products::SinglePackagingsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @single_packaging = single_packagings(:milk25_packaging)
      @product = @single_packaging.product
      sign_in :daniyar
    end

    test "should get index" do
      get product_single_packagings_url(@product)
      assert_response :success
    end

    test "should get new" do
      get new_product_single_packaging_url(@product)
      assert_response :success
    end

    test "should create single_packaging" do
      assert_difference("SinglePackaging.count") do
        post product_single_packagings_url(@product), params: { single_packaging: { material_asset_id: material_assets(:mini_bottle).id } }
      end

      assert_redirected_to edit_product_url(@product)
    end

    test "should get edit" do
      get edit_product_single_packaging_url(@product, @single_packaging)
      assert_response :success
    end

    test "should update single_packaging" do
      patch product_single_packaging_url(@product, @single_packaging), params: { single_packaging: { material_asset_id: material_assets(:mini_bottle).id } }
      assert_redirected_to edit_product_url(@product)
    end

    test "should destroy single_packaging" do
      assert_difference("SinglePackaging.active.count", -1) do
        delete product_single_packaging_url(@product, @single_packaging)
      end

      assert_redirected_to edit_product_url(@product)
    end
  end
end
