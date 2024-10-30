require "test_helper"

class Warehouse::BoxesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in :daniyar
  end

  test "should get index" do
    get boxes_url
    assert_response :success
  end
end
