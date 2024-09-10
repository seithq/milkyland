require "test_helper"

module Production
  class Plans::SummariesControllerTest < ActionDispatch::IntegrationTest
    test "should get index" do
      get summaries_index_url
      assert_response :success
    end
  end
end
