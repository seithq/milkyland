require "test_helper"

class Mobile::FeedsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in :daniyar
  end

  test "should show feed" do
    get feed_url
    assert_response :success
  end
end
