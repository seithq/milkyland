require "test_helper"

class LocationTest < ActiveSupport::TestCase
  test "should attach box to pallet" do
    box = Box.new(region: regions(:almaty),
                  product: products(:milk25),
                  production_date: Date.current,
                  expiration_date: Date.tomorrow,
                  capacity: 5)
    assert box.save

    pallet = Pallet.new
    assert pallet.save

    assert box.locate_to pallet

    assert_equal 1, box.locations.count
    assert_equal 0, box.elements.count
    assert_equal pallet, box.pallets.first

    assert_equal 0, pallet.locations.count
    assert_equal 1, pallet.elements.count
    assert_equal box, pallet.boxes.first
  end

  test "should attach box to pallet and then for new one" do
    box = Box.new(region: regions(:almaty),
                  product: products(:milk25),
                  production_date: Date.current,
                  expiration_date: Date.tomorrow,
                  capacity: 5)
    assert box.save

    pallet = Pallet.new
    assert pallet.save

    assert box.locate_to pallet

    new_pallet = Pallet.new
    assert new_pallet.save

    assert box.locate_to new_pallet

    assert_equal 2, box.all_locations.count
    assert_equal 1, box.locations.count
    assert_equal 0, box.elements.count
    assert_equal new_pallet, box.pallets.first

    assert_equal 0, pallet.elements.count
    assert_equal 1, new_pallet.elements.count
    assert_equal box, new_pallet.boxes.first
  end
end
