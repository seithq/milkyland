require "test_helper"

class DistributedProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @distributed_product = distributed_products(:one)
  end

  test "should get index" do
    get distributed_products_url
    assert_response :success
  end

  test "should get new" do
    get new_distributed_product_url
    assert_response :success
  end

  test "should create distributed_product" do
    assert_difference("DistributedProduct.count") do
      post distributed_products_url, params: { distributed_product: { count: @distributed_product.count, distribution_id: @distributed_product.distribution_id, packaged_product_id: @distributed_product.packaged_product_id, production_date: @distributed_product.production_date, region_id: @distributed_product.region_id } }
    end

    assert_redirected_to distributed_product_url(DistributedProduct.last)
  end

  test "should show distributed_product" do
    get distributed_product_url(@distributed_product)
    assert_response :success
  end

  test "should get edit" do
    get edit_distributed_product_url(@distributed_product)
    assert_response :success
  end

  test "should update distributed_product" do
    patch distributed_product_url(@distributed_product), params: { distributed_product: { count: @distributed_product.count, distribution_id: @distributed_product.distribution_id, packaged_product_id: @distributed_product.packaged_product_id, production_date: @distributed_product.production_date, region_id: @distributed_product.region_id } }
    assert_redirected_to distributed_product_url(@distributed_product)
  end

  test "should destroy distributed_product" do
    assert_difference("DistributedProduct.count", -1) do
      delete distributed_product_url(@distributed_product)
    end

    assert_redirected_to distributed_products_url
  end
end
