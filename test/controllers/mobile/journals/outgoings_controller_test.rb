require "test_helper"

module Mobile
  class Journals::OutgoingsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in :daniyar
    end

    test "should get index" do
      get journals_outgoings_url
      assert_response :success
    end
  end
end
