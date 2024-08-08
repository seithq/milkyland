require "test_helper"

class RegionTest < ActiveSupport::TestCase
  test "should validate uniqueness of name" do
    region = Region.new(name: regions(:aktobe).name, code: "02")
    assert_not region.save
    assert_equal :taken, region.errors.where(:name).first.type
  end

  test "should validate uniqueness of code" do
    region = Region.new(name: "Almaty", code: regions(:aktobe).code)
    assert_not region.save
    assert_equal :taken, region.errors.where(:code).first.type
  end
end
