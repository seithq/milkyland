require "test_helper"

module Sales
  class Orders::PositionsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @position = positions(:opening_milk25)
      @order = @position.order
      @channel = @order.sales_channel
    end

    test "should get index" do
      sign_in :daniyar
      get sales_channel_order_positions_url(@channel, @order)
      assert_response :success
    end

    test "should get new" do
      sign_in :daniyar
      get new_sales_channel_order_position_url(@channel, @order)
      assert_response :success
    end

    test "should create position" do
      sign_in :daniyar
      assert_difference("Position.count") do
        post sales_channel_order_positions_url(@channel, @order), params: { position: { base_price: @position.base_price, count: @position.count, discounted_price: @position.discounted_price, promotion_id: @position.promotion_id, product_id: @position.product_id, total_sum: @position.total_sum } }
      end

      assert_redirected_to edit_sales_channel_order_url(@channel, @order)
    end

    test "should get edit" do
      sign_in :daniyar
      get edit_sales_channel_order_position_url(@channel, @order, @position)
      assert_response :success
    end

    test "should update position" do
      sign_in :daniyar
      patch sales_channel_order_position_url(@channel, @order, @position), params: { position: { count: 10 } }
      assert_redirected_to edit_sales_channel_order_url(@channel, @order)
    end

    test "should destroy position" do
      sign_in :daniyar
      assert_difference("Position.count", -1) do
        delete sales_channel_order_position_url(@channel, @order, @position)
      end

      assert_redirected_to edit_sales_channel_order_url(@channel, @order)
    end
  end
end
