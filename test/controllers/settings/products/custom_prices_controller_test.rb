require "test_helper"

module Settings
  class Products::CustomPricesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @custom_price = custom_prices(:milk25_systemd)
      @product = @custom_price.product
      sign_in :daniyar
    end

    test "should get index" do
      get product_custom_prices_url(@product)
      assert_response :success
    end

    test "should get new" do
      get new_product_custom_price_url(@product)
      assert_response :success
    end

    test "should create custom_price" do
      assert @custom_price.destroy
      assert_difference("CustomPrice.count") do
        post product_custom_prices_url(@product), params: { custom_price: { client_id: @custom_price.client_id, value: 1000 } }
      end

      assert_redirected_to edit_product_url(@product)
    end

    test "should get edit" do
      get edit_product_custom_price_url(@product, @custom_price)
      assert_response :success
    end

    test "should update custom_price" do
      patch product_custom_price_url(@product, @custom_price), params: { custom_price: { value: 1000 } }
      assert_redirected_to edit_product_url(@product)
    end

    test "should destroy custom_price" do
      assert_difference("CustomPrice.active.count", -1) do
        delete product_custom_price_url(@product, @custom_price)
      end

      assert_redirected_to edit_product_url(@product)
    end
  end
end
