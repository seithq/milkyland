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
end
