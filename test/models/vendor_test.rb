require "test_helper"

class VendorTest < ActiveSupport::TestCase
  test "should validate uniqueness of vendor" do
    vendor = Vendor.new material_asset: material_assets(:sugar),
                        supplier: suppliers(:systemd),
                        entry_price: 100,
                        delivery_time_in_days: 5
    assert vendor.invalid?
    assert_equal :taken, vendor.errors.where(:supplier_id).first.type
  end
end
