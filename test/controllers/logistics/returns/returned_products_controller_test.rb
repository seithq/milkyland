require "test_helper"

module Logistics
  class Returns::ReturnedProductsControllerTest < ActionDispatch::IntegrationTest
    setup do
      create_return_for_departure
      sign_in :daniyar
    end

    test "should get new" do
      get new_return_returned_product_url(@return)
      assert_response :success
    end

    test "should create returned_product" do
      @returned_product.destroy

      assert_difference("ReturnedProduct.count") do
        post return_returned_products_url(@return), params: { returned_product: { count: 1, product_id: products(:milk25).id } }
      end

      assert_redirected_to edit_return_url(@return)
    end

    test "should get edit" do
      get edit_return_returned_product_url(@return, @returned_product)
      assert_response :success
    end

    test "should update returned_product" do
      patch return_returned_product_url(@return, @returned_product), params: { returned_product: { count: 2 } }
      assert_redirected_to edit_return_url(@return)
    end

    test "should destroy returned_product" do
      assert_difference("ReturnedProduct.count", -1) do
        delete return_returned_product_url(@return, @returned_product)
      end

      assert_redirected_to return_returned_products_url(@return)
    end

    private
      def create_return_for_departure
        @waybill = Waybill.new kind: :departure,
                               status: :approved,
                               order: orders(:opening),
                               storage: storages(:goods),
                               sender: users(:daniyar)
        assert @waybill.save
        assert @waybill.leftovers.create subject: products(:milk25), count: 6

        @return = Return.new user: users(:daniyar),
                             order: orders(:opening),
                             storage: storages(:goods)
        assert @return.save

        @returned_product = @return.returned_products.new product: products(:milk25), count: 2
        assert @returned_product.save
      end
  end
end
