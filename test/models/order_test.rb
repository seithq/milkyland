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
end
