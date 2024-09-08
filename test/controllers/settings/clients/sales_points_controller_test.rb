require "test_helper"

module Settings
  class Clients::SalesPointsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @sales_point = sales_points(:seit)
      @client = @sales_point.client
    end

    test "should get index" do
      sign_in :daniyar
      get client_sales_points_url(@client)
      assert_response :success
    end

    test "should get new" do
      sign_in :daniyar
      get new_client_sales_point_url(@client)
      assert_response :success
    end

    test "should create sales_point" do
      sign_in :daniyar
      assert_difference("SalesPoint.count") do
        post client_sales_points_url(@client), params: { sales_point: { address: "New Address", name: "New Store", region_id: regions(:almaty).id } }
      end

      assert_redirected_to edit_client_url(@client)
    end

    test "create does not allow non-admins to create record" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      channel = SalesChannel.create!(name: "Test")
      post client_sales_points_url(@client), params: { sales_point: { address: "New Address", name: "New Store", region_id: regions(:almaty).id } }
      assert_response :forbidden
    end

    test "should get edit" do
      sign_in :daniyar
      get edit_client_sales_point_url(@client, @sales_point)
      assert_response :success
    end

    test "should update sales_point" do
      sign_in :daniyar
      patch client_sales_point_url(@client, @sales_point), params: { sales_point: { address: "New Address", phone_number: "" } }
      assert_redirected_to edit_client_url(@client)
    end

    test "update does not allow non-admins to change roles" do
      sign_in :askhat
      assert_not users(:askhat).admin?

      patch client_sales_point_url(@client, @sales_point), params: { sales_point: { address: "New Address", phone_number: "" } }
      assert_response :forbidden
    end

    test "should destroy sales_point" do
      sign_in :daniyar
      assert_difference("SalesPoint.active.count", -1) do
        delete client_sales_point_url(@client, @sales_point)
      end

      assert_redirected_to edit_client_url(@client)
    end
  end
end
