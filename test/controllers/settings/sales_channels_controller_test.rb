require "test_helper"

class Settings::SalesChannelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sales_channel = sales_channels(:b2c)
  end

  test "should get index" do
    sign_in :daniyar
    get sales_channels_url
    assert_response :success
  end

  test "should get new" do
    sign_in :daniyar
    get new_sales_channel_url
    assert_response :success
  end

  test "should create sales_channel" do
    sign_in :daniyar
    assert_difference("SalesChannel.count") do
      post sales_channels_url, params: { sales_channel: { name: "b2r" } }
    end

    assert_redirected_to sales_channels_url
  end

  test "create does not allow non-admins to create record" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    post sales_channels_url, params: { sales_channel: { name: "b2r" } }
    assert_response :forbidden
  end

  test "should show sales_channel" do
    sign_in :daniyar
    get sales_channel_url(@sales_channel)
    assert_response :success
  end

  test "should get edit" do
    sign_in :daniyar
    get edit_sales_channel_url(@sales_channel)
    assert_response :success
  end

  test "should update sales_channel" do
    sign_in :daniyar
    patch sales_channel_url(@sales_channel), params: { sales_channel: { name: "b2r" } }
    assert_redirected_to sales_channels_url
  end

  test "update does not allow non-admins to change roles" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    patch sales_channel_url(@sales_channel), params: { sales_channel: { name: "b2r" } }
    assert_response :forbidden
  end
end
