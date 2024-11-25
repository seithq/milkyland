require "test_helper"

class SemiProductTest < ActiveSupport::TestCase
  test "should validate uniqueness name" do
    product = SemiProduct.new(name: semi_products(:bom).name)
    assert product.invalid?
    assert_equal :taken, product.errors.where(:name).first.type
  end

  test "should validate presence of required fields" do
    product = SemiProduct.new
    assert product.invalid?
    assert_equal :blank, product.errors.where(:name).first.type
    assert_equal :blank, product.errors.where(:expiration_in_days).first.type
  end
end
