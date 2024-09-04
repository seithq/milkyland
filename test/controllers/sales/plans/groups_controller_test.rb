require "test_helper"

module Sales
  class Plans::GroupsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @order = orders(:opening)
      assert @order.update(preferred_date: 10.days.from_now)
      @plan = Plan.last
    end

    test "should get index" do
      sign_in :daniyar
      get plan_groups_url(@plan)
      assert_response :success
    end
  end
end
