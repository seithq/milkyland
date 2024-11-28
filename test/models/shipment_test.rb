require "test_helper"

class ShipmentTest < ActiveSupport::TestCase
  test "should validate presence of supplier" do
    plan = Plan.new production_date: Date.current
    shipment = Shipment.new plan: plan, region: regions(:almaty), kind: :external, shipping_date: Date.current
    assert shipment.invalid?
    assert_equal :blank, shipment.errors.where(:client_id).first.type
  end

  test "should clear client on internal" do
    plan = Plan.new production_date: Date.current
    shipment = Shipment.new plan: plan, region: regions(:almaty), kind: :external, client: clients(:systemd), shipping_date: Date.current
    assert shipment.save

    assert shipment.update kind: :internal
    assert_not shipment.reload.client
  end
end
