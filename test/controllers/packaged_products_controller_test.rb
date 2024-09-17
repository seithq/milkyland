require "test_helper"

class PackagedProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @packaged_product = packaged_products(:one)
  end

  test "should get index" do
    get packaged_products_url
    assert_response :success
  end

  test "should get new" do
    get new_packaged_product_url
    assert_response :success
  end

  test "should create packaged_product" do
    assert_difference("PackagedProduct.count") do
      post packaged_products_url, params: { packaged_product: { count: @packaged_product.count, end_time: @packaged_product.end_time, packing_id: @packaged_product.packing_id, product_id: @packaged_product.product_id, start_time: @packaged_product.start_time } }
    end

    assert_redirected_to packaged_product_url(PackagedProduct.last)
  end

  test "should show packaged_product" do
    get packaged_product_url(@packaged_product)
    assert_response :success
  end

  test "should get edit" do
    get edit_packaged_product_url(@packaged_product)
    assert_response :success
  end

  test "should update packaged_product" do
    patch packaged_product_url(@packaged_product), params: { packaged_product: { count: @packaged_product.count, end_time: @packaged_product.end_time, packing_id: @packaged_product.packing_id, product_id: @packaged_product.product_id, start_time: @packaged_product.start_time } }
    assert_redirected_to packaged_product_url(@packaged_product)
  end

  test "should destroy packaged_product" do
    assert_difference("PackagedProduct.count", -1) do
      delete packaged_product_url(@packaged_product)
    end

    assert_redirected_to packaged_products_url
  end
end
