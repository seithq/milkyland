require "test_helper"

module Sales
  class Plans::ConsolidationsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @order = orders(:opening)
      assert @order.update(preferred_date: 10.days.from_now)
      @plan = Plan.last
      @consolidation = @plan.consolidations.last
    end

    test "should get index" do
      sign_in :daniyar
      get plan_consolidations_url(@plan)
      assert_response :success
    end

    test "should get edit" do
      sign_in :daniyar
      get edit_plan_consolidation_url(@plan, @consolidation)
      assert_response :success
    end

    test "should update consolidation" do
      sign_in :daniyar
      patch plan_consolidation_url(@plan, @consolidation), params: { consolidation: { active: true } }
      assert_redirected_to edit_plan_url(@plan)
    end

    test "should destroy consolidation" do
      sign_in :daniyar
      assert_difference("Consolidation.active.count", -1) do
        delete plan_consolidation_url(@plan, @consolidation)
      end

      assert_redirected_to edit_plan_url(@plan)
    end
  end
end
