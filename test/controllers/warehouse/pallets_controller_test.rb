require "test_helper"

class Warehouse::PalletsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in :daniyar
  end

  test "should get index" do
    get pallets_url
    assert_response :success
  end
end
