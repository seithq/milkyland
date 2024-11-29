require "test_helper"

class TrackingProductTest < ActiveSupport::TestCase
  test "should validate unrestricted count" do
    tracking_product = TrackingProduct.new count: 100, unrestricted_count: 150
    assert tracking_product.invalid?
    assert_equal :less_than_or_equal_to, tracking_product.errors.where(:unrestricted_count).first.type
  end
end
