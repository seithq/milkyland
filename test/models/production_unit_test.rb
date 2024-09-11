require "test_helper"

class ProductionUnitTest < ActiveSupport::TestCase
  def create_plan
    production_date = 10.days.from_now
    plan = Plan.new(status: :in_consolidation, production_date: production_date)
    assert plan.save

    order = orders(:opening)
    assert_difference -> { plan.consolidations.count }, 1 do
      assert order.update(preferred_date: production_date)
    end

    assert_difference -> { plan.orders.filter_by_status(:in_production).count }, 1 do
      assert plan.update(status: :in_production)
    end

    plan
  end

  test "should validate presence of count" do
    plan = create_plan
    unit = ProductionUnit.new(plan: plan, group: groups(:milk25), tonnage: 1.5)
    assert unit.invalid?
    assert_equal :blank, unit.errors.where(:count).first.type
  end

  test "should validate presence of tonnage" do
    plan = create_plan
    unit = ProductionUnit.new(plan: plan, group: groups(:milk25), count: 100)
    assert unit.invalid?
    assert_equal :blank, unit.errors.where(:tonnage).first.type
  end

  test "should validate uniqueness of group" do
    plan = create_plan
    unit = ProductionUnit.new(plan: plan, group: groups(:milk25), count: 100, tonnage: 1.0)
    assert unit.invalid?
    assert_equal :taken, unit.errors.where(:group_id).first.type
  end
end
