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

  test "should update route sheets status" do
    shipment = Shipment.new kind: :external,
                            region: regions(:almaty),
                            client: clients(:systemd),
                            shipping_date: Date.current
    assert shipment.save
    assert shipment.route_sheets.create vehicle_plate_number: "272MNB02",
                                        driver_name: "Daniyar",
                                        driver_phone_number: "+77772514515"

    assert shipment.update status: :ready_to_collect
    assert_equal shipment.status, shipment.route_sheets.last.status
  end

  test "should not update route sheets status" do
    shipment = Shipment.new kind: :external,
                            region: regions(:almaty),
                            client: clients(:systemd),
                            shipping_date: Date.current
    assert shipment.save
    assert shipment.route_sheets.create vehicle_plate_number: "272MNB02",
                                        driver_name: "Daniyar",
                                        driver_phone_number: "+77772514515",
                                        status: :completed

    assert shipment.update status: :ready_to_collect
    assert shipment.route_sheets.last.completed?
  end

  test "should update status if route sheet completed" do
    shipment = Shipment.new kind: :external,
                            region: regions(:almaty),
                            client: clients(:systemd),
                            shipping_date: Date.current,
                            status: :ready_to_collect
    assert shipment.save
    assert shipment.route_sheets.create vehicle_plate_number: "272MNB02",
                                        driver_name: "Daniyar",
                                        driver_phone_number: "+77772514515",
                                        status: :completed
    assert shipment.reload.completed?
  end

  test "should keep shipment status on route sheets delete" do
    shipment = Shipment.new kind: :external,
                            region: regions(:almaty),
                            client: clients(:systemd),
                            shipping_date: Date.current
    assert shipment.save
    assert shipment.route_sheets.create vehicle_plate_number: "272MNB02",
                                        driver_name: "Daniyar",
                                        driver_phone_number: "+77772514515"

    assert shipment.update status: :ready_to_collect
    assert_equal shipment.status, shipment.route_sheets.last.status

    assert shipment.route_sheets.last.destroy
    assert shipment.reload.ready_to_collect?
  end
end
