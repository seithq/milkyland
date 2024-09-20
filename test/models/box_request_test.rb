require "test_helper"

class BoxRequestTest < ActiveSupport::TestCase
  test "should validate presence of count" do
    box_request = BoxRequest.new
    assert box_request.invalid?
    assert_equal :blank, box_request.errors.where(:count).first.type
  end
end
