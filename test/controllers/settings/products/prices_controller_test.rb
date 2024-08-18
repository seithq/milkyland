require "test_helper"

module Settings
  class Products::PricesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @price = prices(:milk25_b2c)
      @product = @price.product
    end

    test "should get index" do
      sign_in :daniyar
      get product_prices_url(@product)
      assert_response :success
    end

    test "should get new" do
      sign_in :daniyar
      get new_product_price_url(@product)
      assert_response :success
    end

    test "should create price" do
      sign_in :daniyar
      channel = SalesChannel.create!(name: "Test")
      assert_difference("Price.count") do
        post product_prices_url(@product), params: { price: { sales_channel_id: channel.id, value: "750" } }
      end

      assert_redirected_to edit_product_url(@product)
    end

    test "create does not allow non-admins to create record" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      channel = SalesChannel.create!(name: "Test")
      post product_prices_url(@product), params: { price: { sales_channel_id: channel.id, value: "750" } }
      assert_response :forbidden
    end

    test "should get edit" do
      sign_in :daniyar
      get edit_product_price_url(@product, @price)
      assert_response :success
    end

    test "should update price" do
      sign_in :daniyar
      patch product_price_url(@product, @price), params: { price: { value: "800" } }
      assert_redirected_to edit_product_url(@product)
    end

    test "update does not allow non-admins to change roles" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      patch product_price_url(@product, @price), params: { price: { value: "800" } }
      assert_response :forbidden
    end

    test "should destroy price" do
      sign_in :daniyar
      assert_difference("Price.active.count", -1) do
        delete product_price_url(@product, @price)
      end

      assert_redirected_to edit_product_url(@product)
    end
  end
end
