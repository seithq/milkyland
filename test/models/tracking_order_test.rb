require "test_helper"

class TrackingOrderTest < ActiveSupport::TestCase
  test "should calculate tracking products using orders" do
    shipment = Shipment.new kind: :external,
                            client: clients(:systemd),
                            region: regions(:almaty),
                            shipping_date: Date.current
    assert shipment.save

    route_sheet = shipment.route_sheets.new vehicle_plate_number: "916YGA02",
                                            driver_name: "SEITKASSYM",
                                            driver_phone_number: "+77777162025"
    assert route_sheet.save

    assert_difference "TrackingProduct.count", 1 do
      tracking_order = route_sheet.tracking_orders.new order: orders(:opening)
      assert tracking_order.save
      assert_equal route_sheet.tracking_products.first.count, positions(:opening_milk25).count
    end

    assert_difference "TrackingProduct.count", -1 do
      route_sheet.tracking_orders.destroy_all
    end
  end
end
