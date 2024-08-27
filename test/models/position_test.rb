require "test_helper"

class PositionTest < ActiveSupport::TestCase
  test "should validate numericality of count" do
    position = Position.new(count: 100.0, base_price: 100.0, discounted_price: 100.0)
    assert position.invalid?
    assert_equal :not_an_integer, position.errors.where(:count).first.type
  end

  test "should validate presence of fields" do
    position = Position.new(order: orders(:opening), product: products(:milk25))
    assert position.invalid?

    assert_equal :blank, position.errors.where(:count).first.type
    assert_equal :blank, position.errors.where(:base_price).first.type
    assert_equal :blank, position.errors.where(:discounted_price).first.type
    assert_equal :greater_than, position.errors.where(:total_sum).first.type
  end

  test "should validate discount price is lest or equal to base price" do
    position = Position.new(order: orders(:opening),
                            product: products(:milk25),
                            count: 1,
                            base_price: 1000.0,
                            discounted_price: 1100.0,
                            total_sum: 1100.0)
    assert position.invalid?
    assert_equal :less_than_or_equal_to, position.errors.where(:discounted_price).first.type
  end

  test "should validate total sum is equal to final price multiplied by count" do
    position = Position.new(order: orders(:opening),
                            product: products(:milk25),
                            count: 1,
                            base_price: 1000.0,
                            discounted_price: 900.0,
                            total_sum: 1000.0)
    assert position.invalid?
    assert_equal :equal_to, position.errors.where(:total_sum).first.type
  end

  test "should set total sum if zero" do
    position = Position.new(order: orders(:opening),
                            product: products(:milk25),
                            count: 1,
                            base_price: 1000.0,
                            discounted_price: 900.0)
    assert position.valid?
    assert_equal 900.0, position.total_sum
  end
end
