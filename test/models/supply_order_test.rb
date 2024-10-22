require "test_helper"

class SupplyOrderTest < ActiveSupport::TestCase
  test "should validate presence of amount" do
    supply_order = SupplyOrder.new(material_asset: material_assets(:sugar), payment_date: Date.current)
    assert supply_order.invalid?
    assert_equal :blank, supply_order.errors.where(:amount).first.type
  end

  test "should validate numericality of amount" do
    supply_order = SupplyOrder.new(material_asset: material_assets(:sugar), payment_date: Date.current, amount: 0.0)
    assert supply_order.invalid?
    assert_equal :greater_than, supply_order.errors.where(:amount).first.type
  end

  test "should validate presence of payment date" do
    supply_order = SupplyOrder.new(material_asset: material_assets(:sugar), amount: 1000.0)
    assert supply_order.invalid?
    assert_equal :blank, supply_order.errors.where(:payment_date).first.type
  end

  test "should validate comparison of payment date" do
    supply_order = SupplyOrder.new(material_asset: material_assets(:sugar), payment_date: 1.day.ago, amount: 1000.0)
    assert supply_order.invalid?
    assert_equal :greater_than_or_equal_to, supply_order.errors.where(:payment_date).first.type
  end
end
