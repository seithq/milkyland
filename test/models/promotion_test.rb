require "test_helper"

class PromotionTest < ActiveSupport::TestCase
  test "should validate presence of name" do
    promo = Promotion.new(kind: :by_percent, start_date: Time.zone.today, end_date: 3.days.from_now)
    assert_not promo.save
    assert_equal :blank, promo.errors.where(:name).first.type
  end

  test "should validate uniqueness of name" do
    promo = Promotion.new(name: promotions(:big_deal).name, kind: :by_percent, start_date: Time.zone.today, end_date: 3.days.from_now)
    assert_not promo.save
    assert_equal :taken, promo.errors.where(:name).first.type
  end

  test "should validate presence of start and end dates" do
    promo = Promotion.new(name: "New Promo", kind: :by_percent, discount: 10.0)
    assert_not promo.save
    assert_equal :blank, promo.errors.where(:start_date).first.type
    assert_equal :blank, promo.errors.where(:end_date).first.type
  end

  test "should not validate presence of start and end dates for unlimited" do
    promo = Promotion.new(name: "New Promo", kind: :by_percent, discount: 10.0, unlimited: true)
    assert promo.save
  end

  test "should validate presence of discount" do
    promo = Promotion.new(name: "New Promo", kind: :by_percent, unlimited: true)
    assert_not promo.save
    assert_equal :blank, promo.errors.where(:discount).first.type
  end

  test "should validate numericality of discount" do
    promo = Promotion.new(name: "New Promo", kind: :by_percent, discount: 0.0, unlimited: true)
    assert_not promo.save
    assert_equal :greater_than, promo.errors.where(:discount).first.type
  end

  test "should validate active method for running promo" do
    promo = promotions(:big_deal)
    assert promo.running?

    assert promo.update(start_date: Time.zone.today, end_date: Time.zone.today)
    assert promo.running?

    assert promo.update(start_date: 7.days.ago, end_date: 3.days.ago)
    assert_not promo.running?

    assert promo.update(unlimited: true)
    assert promo.running?
  end

  test "should normalize dates for unlimited promo" do
    promo = promotions(:big_deal)
    assert promo.running?

    assert promo.update(unlimited: true)
    assert promo.running?

    assert_not promo.start_date?
    assert_not promo.end_date?
  end

  test "should validate active scope" do
    promo = Promotion.new(name: "New Promo", kind: :by_percent, discount: 10.0, start_date: 7.days.ago, end_date: 3.days.ago)
    assert promo.save

    assert_equal 1, Promotion.running.count

    assert promo.update(unlimited: true)
    assert_equal 2, Promotion.running.count
  end

  test "should validate calculated discount" do
    promo = promotions(:big_deal)
    product = products(:milk25)

    discounted_price = promo.calculate_discount_for product.prices.first.value
    assert_equal 90.0, discounted_price
  end
end
