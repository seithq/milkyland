require "test_helper"

class PlanTest < ActiveSupport::TestCase
  test "should validate presence of production date" do
    plan = Plan.new(status: :in_consolidation)
    assert plan.invalid?
    assert_equal :blank, plan.errors.where(:production_date).first.type
  end

  test "should validate value of production date" do
    plan = Plan.new(status: :in_consolidation, production_date: 1.day.ago)
    assert plan.invalid?
    assert_equal :greater_than_or_equal_to, plan.errors.where(:production_date).first.type
  end

  test "should update orders if moved to production" do
    order = orders(:opening)
    production_date = order.preferred_date + 3.days

    plan = Plan.new(status: :in_consolidation, production_date: production_date)
    assert plan.save

    assert_difference -> { plan.consolidations.count }, 1 do
      assert order.update(preferred_date: production_date)
    end

    assert_difference -> { plan.orders.filter_by_status(:in_production).count }, 1 do
      assert_difference -> { plan.units.count }, 1 do
        assert plan.update(status: :in_production)
      end
    end
  end

  test "should deactivate consolidations and mark order as cancelled" do
    order = orders(:opening)
    production_date = order.preferred_date + 3.days

    plan = Plan.new(status: :in_consolidation, production_date: production_date)
    assert plan.save

    assert_difference -> { plan.consolidations.count }, 1 do
      assert order.update(preferred_date: production_date)
    end

    assert_difference -> { plan.orders.filter_by_status(:cancelled).count }, 1 do
      assert plan.cancel
    end
  end
end
