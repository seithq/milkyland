require "test_helper"

class DiscountedProductTest < ActiveSupport::TestCase
  test "should validate uniqueness of product id" do
    product = DiscountedProduct.new(promotion_id: promotions(:big_deal).id, product_id: products(:milk25).id)
    assert_not product.save
    assert_equal :taken, product.errors.where(:product_id).first.type
  end
end
