require "test_helper"

class PriceTest < ActiveSupport::TestCase
  test "should validate presence of value" do
    channel = SalesChannel.new(name: "Tengiz")
    assert channel.save

    price = Price.new(product: products(:milk25), sales_channel: channel)
    assert_not price.save
    assert_equal :blank, price.errors.where(:value).first.type
  end

  test "should validate value is greater than 0" do
    channel = SalesChannel.new(name: "Tengiz")
    assert channel.save

    price = Price.new(product: products(:milk25), sales_channel: channel, value: 0.0)
    assert_not price.save
    assert_equal :greater_than, price.errors.where(:value).first.type
  end

  test "should validate uniqueness of sales channel" do
    price = Price.new(product: products(:milk25), sales_channel: sales_channels(:b2b), value: 1000)
    assert_not price.save
    assert_equal :taken, price.errors.where(:sales_channel_id).first.type
  end
end
