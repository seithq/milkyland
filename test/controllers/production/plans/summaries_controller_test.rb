require "test_helper"

module Production
  class Plans::SummariesControllerTest < ActionDispatch::IntegrationTest
    setup do
      sample_generation
      sign_in :daniyar
    end

    test "should get index" do
      get production_plan_summary_url(@plan)
      assert_response :success
    end
  end
end
