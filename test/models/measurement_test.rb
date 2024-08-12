require "test_helper"

class MeasurementTest < ActiveSupport::TestCase
  test "should validate presence of name" do
    measurement = Measurement.new(unit: "l")
    assert_not measurement.save
    assert_equal :blank, measurement.errors.where(:name).first.type
  end

  test "should validate presence of unit" do
    measurement = Measurement.new(name: "Pieces")
    assert_not measurement.save
    assert_equal :blank, measurement.errors.where(:unit).first.type
  end

  test "should validate uniqueness of unit" do
    measurement = Measurement.new(name: "Pieces", unit: measurements(:kilogram).unit)
    assert_not measurement.save
    assert_equal :taken, measurement.errors.where(:unit).first.type
  end
end
