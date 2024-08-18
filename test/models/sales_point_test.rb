require "test_helper"

class SalesPointTest < ActiveSupport::TestCase
  test "should validate presence of name and address" do
    sales_point = SalesPoint.new
    assert_not sales_point.save
    assert_equal :blank, sales_point.errors.where(:name).first.type
    assert_equal :blank, sales_point.errors.where(:address).first.type
  end

  test "should validate uniqueness of name" do
    sales_point = SalesPoint.new(client: clients(:systemd), address: "New Address", name: sales_points(:seit).name)
    assert_not sales_point.save
    assert_equal :taken, sales_point.errors.where(:name).first.type
  end

  test "should validate format of phone number" do
    sales_point = SalesPoint.new(client: clients(:systemd), address: "New Address", name: "New Store", phone_number: "7272381889")
    assert_not sales_point.save
    assert_equal :invalid, sales_point.errors.where(:phone_number).first.type
  end
end
