require "test_helper"

module Production
  class Plans::SummariesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @order = orders(:opening)
      assert @order.update preferred_date: 10.days.from_now
      @plan = Plan.last
      assert @plan.update status: :ready_to_production
    end

    test "should get index" do
      sign_in :daniyar
      get production_plan_summary_url(@plan)
      assert_response :success
    end
  end
end
