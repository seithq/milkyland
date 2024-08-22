require "test_helper"

module Settings
  class Promotions::DiscountedProductsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @discounted_product = discounted_products(:big_deal_milk25)
      @promotion = @discounted_product.promotion
    end

    test "should get index" do
      sign_in :daniyar
      get promotion_discounted_products_url(@promotion)
      assert_response :success
    end

    test "should get new" do
      sign_in :daniyar
      get new_promotion_discounted_product_url(@promotion)
      assert_response :success
    end

    test "should create discounted_product" do
      sign_in :daniyar
      assert_difference("DiscountedProduct.count") do
        post promotion_discounted_products_url(@promotion), params: { discounted_product: { product_id: products(:milk25_big).id } }
      end

      assert_redirected_to edit_promotion_url(@promotion)
    end

    test "create does not allow non-admins to create record" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      post promotion_discounted_products_url(@promotion), params: { discounted_product: { product_id: products(:milk25_big).id } }
      assert_response :forbidden
    end

    test "should get edit" do
      sign_in :daniyar
      get edit_promotion_discounted_product_url(@promotion, @discounted_product)
      assert_response :success
    end

    test "should update discounted_product" do
      sign_in :daniyar
      patch promotion_discounted_product_url(@promotion, @discounted_product), params: { discounted_product: { product_id: products(:milk25_big).id } }
      assert_redirected_to edit_promotion_url(@promotion)
    end

    test "update does not allow non-admins to change roles" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      patch promotion_discounted_product_url(@promotion, @discounted_product), params: { discounted_product: { product_id: products(:milk25_big).id } }
      assert_response :forbidden
    end

    test "should destroy discounted_product" do
      sign_in :daniyar
      assert_difference("DiscountedProduct.active.count", -1) do
        delete promotion_discounted_product_url(@promotion, @discounted_product)
      end

      assert_redirected_to edit_promotion_url(@promotion)
    end
  end
end
