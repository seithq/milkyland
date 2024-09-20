require "test_helper"

class BoxTest < ActiveSupport::TestCase
  test "should generate code before creation" do
    gen = sample_generation
    req = gen.box_requests.new(box_packaging: box_packagings(:bottle_milk25), count: 6)

    box = Box.new \
      region: regions(:almaty),
      product: products(:milk25),
      capacity: 6,
      production_date: 3.days.from_now,
      expiration_date: 6.days.from_now,
      box_request: req
    assert box.save
    assert box.code
  end
end
