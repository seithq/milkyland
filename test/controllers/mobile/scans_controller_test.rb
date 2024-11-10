require "test_helper"

class Mobile::ScansControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in :daniyar
  end

  test "should get index" do
    get scans_url
    assert_response :success
  end

  test "should get index with code" do
    get scans_url(code: zones(:goods_zone).code)
    assert_response :success
  end
end
