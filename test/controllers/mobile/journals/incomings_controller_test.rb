require "test_helper"

module Mobile
  class Journals::IncomingsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in :daniyar
    end

    test "should get index" do
      get journals_incomings_url
      assert_response :success
    end
  end
end
