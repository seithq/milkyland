require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "should validate uniqueness of article and name" do
    product = Product.new(name: products(:milk25).name, article: products(:milk25).article)
    assert_not product.save
    assert_equal :taken, product.errors.where(:name).first.type
    assert_equal :taken, product.errors.where(:article).first.type
  end

  test "should validate presence of required fields" do
    product = Product.new
    assert_not product.save
    assert_equal :blank, product.errors.where(:name).first.type
    assert_equal :blank, product.errors.where(:article).first.type
    assert_equal :blank, product.errors.where(:packing).first.type
    assert_equal :blank, product.errors.where(:expiration_in_days).first.type
    assert_equal :blank, product.errors.where(:fat_fraction).first.type
  end

  test "should validate fat fraction range" do
    product = Product.new(fat_fraction: 110.0)
    assert_not product.save
    assert_equal :in, product.errors.where(:fat_fraction).first.type
  end

  test "should get price for channel" do
    price = products(:milk25).price by: sales_channels(:b2b).id
    assert_equal prices(:milk25_b2b).value, price.value
  end
end
