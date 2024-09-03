require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "should validate preferred data greater or equal to today" do
    order = orders(:opening)
    order.preferred_date = 1.day.ago
    assert order.invalid?
    assert_equal :greater_than_or_equal_to, order.errors.where(:preferred_date).first.type

    order.preferred_date = Time.zone.today
    assert order.valid?
  end

  test "should create plan on order create" do
    production_date = 3.days.from_now

    order = Order.new(sales_channel: sales_channels(:b2c),
                      client: clients(:systemd),
                      sales_point: sales_points(:seit),
                      preferred_date: production_date)

    assert_difference -> { Plan.count }, 1 do
      assert_difference -> { Consolidation.count }, 1 do
        assert order.save
        assert_equal production_date.to_date, Plan.last.production_date
      end
    end
  end

  test "should not create plan on order create" do
    plan = Plan.new(production_date: 3.days.from_now)
    assert plan.save

    order = Order.new(sales_channel: sales_channels(:b2c),
                      client: clients(:systemd),
                      sales_point: sales_points(:seit),
                      preferred_date: plan.production_date)

    assert_difference -> { Plan.count }, 0 do
      assert_difference -> { Consolidation.count }, 1 do
        assert order.save
      end
    end
  end

  test "should update preferred date for next plan date" do
    production_date = 3.days.from_now
    next_date = 7.days.from_now

    [[:in_production, production_date], [:in_consolidation, next_date]].each do |params|
      plan = Plan.new(status: params.first, production_date: params.second)
      assert plan.save
    end

    order = Order.new(sales_channel: sales_channels(:b2c),
                      client: clients(:systemd),
                      sales_point: sales_points(:seit),
                      preferred_date: production_date)

    assert_difference -> { Plan.count }, 0 do
      assert_difference -> { Consolidation.count }, 1 do
        assert order.save
        assert_equal next_date.to_date, order.preferred_date
        assert_equal Plan.ordered.first, order.current_plan
      end
    end
  end

  test "should update preferred date for next day" do
    production_date = 3.days.from_now
    next_date = production_date + 1.day

    plan = Plan.new(status: :in_production, production_date: production_date)
    assert plan.save

    order = Order.new(sales_channel: sales_channels(:b2c),
                      client: clients(:systemd),
                      sales_point: sales_points(:seit),
                      preferred_date: production_date)

    assert_difference -> { Plan.count }, 1 do
      assert_difference -> { Consolidation.count }, 1 do
        assert order.save
        assert_equal next_date.to_date, order.preferred_date
        assert_equal 1, Plan.where(production_date: next_date).count
        assert_equal Plan.ordered.first, order.current_plan
      end
    end
  end

  test "should deactivate consolidation on order cancel" do
    production_date = 3.days.from_now

    order = Order.new(sales_channel: sales_channels(:b2c),
                      client: clients(:systemd),
                      sales_point: sales_points(:seit),
                      preferred_date: production_date)
    assert order.save

    assert_difference -> { Plan.count }, 0 do
      assert_difference -> { Consolidation.active.count }, -1 do
        assert order.cancel
        assert_not order.current_plan
      end
    end
  end
end
