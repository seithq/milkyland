require "test_helper"

class Settings::SemiProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @semi_product = semi_products(:bom)
  end

  test "should get index" do
    sign_in :daniyar
    get semi_products_url
    assert_response :success
  end

  test "should get new" do
    sign_in :daniyar
    get new_semi_product_url
    assert_response :success
  end

  test "should create semi_product" do
    sign_in :daniyar
    assert_difference("SemiProduct.count") do
      post semi_products_url, params: { semi_product: { name: "BOM NEW",
                                                        expiration_in_days: @semi_product.expiration_in_days,
                                                        group_id: @semi_product.group_id,
                                                        measurement_id: @semi_product.measurement_id,
                                                        storage_conditions: @semi_product.storage_conditions } }
    end

    assert_redirected_to semi_products_url
  end

  test "create does not allow non-admins to create record" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    post semi_products_url, params: { semi_product: { name: "BOM NEW",
                                                      expiration_in_days: @semi_product.expiration_in_days,
                                                      group_id: @semi_product.group_id,
                                                      measurement_id: @semi_product.measurement_id,
                                                      storage_conditions: @semi_product.storage_conditions } }
    assert_response :forbidden
  end

  test "should show semi_product" do
    sign_in :daniyar
    get semi_product_url(@semi_product)
    assert_response :success
  end

  test "should get edit" do
    sign_in :daniyar
    get edit_semi_product_url(@semi_product)
    assert_response :success
  end

  test "should update semi_product" do
    sign_in :daniyar
    patch semi_product_url(@semi_product), params: { semi_product: { name: "NEW BOM" } }
    assert_redirected_to semi_products_url
  end

  test "update does not allow non-admins to change roles" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    patch semi_product_url(@semi_product), params: { semi_product: { name: "NEW BOM" } }
    assert_response :forbidden
  end
end
