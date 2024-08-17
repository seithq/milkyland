require "test_helper"

class Settings::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:milk25)
  end

  test "should get index" do
    sign_in :daniyar
    get products_url
    assert_response :success
  end

  test "should get new" do
    sign_in :daniyar
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    sign_in :daniyar
    assert_difference("Product.count") do
      post products_url, params: { product: { name: "Milk 2.5% 0.5L",
                                              article: "ML25-2",
                                              packing: 0.5,
                                              box_capacity: @product.box_capacity,
                                              expiration_in_days: @product.expiration_in_days,
                                              fat_fraction: @product.fat_fraction,
                                              group_id: @product.group_id,
                                              material_asset_id: @product.material_asset_id,
                                              measurement_id: @product.measurement_id,
                                              storage_conditions: @product.storage_conditions } }
    end

    assert_redirected_to edit_product_url(Product.last)
  end

  test "should show product" do
    sign_in :daniyar
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    sign_in :daniyar
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    sign_in :daniyar
    patch product_url(@product), params: { product: { name: "KIDS MILK" } }
    assert_redirected_to products_url
  end
end
