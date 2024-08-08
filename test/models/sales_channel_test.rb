require "test_helper"

class SalesChannelTest < ActiveSupport::TestCase
  test "should validate uniqueness of name" do
    channel = SalesChannel.new(name: sales_channels(:b2c).name)
    assert_not channel.save
    assert_equal :taken, channel.errors.where(:name).first.type
  end
end
