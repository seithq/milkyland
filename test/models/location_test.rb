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

  test "should attach zone to storage" do
    storage = storages(:masters)

    zone = Zone.new kind: :hold
    assert zone.save

    assert zone.locate_to storage

    assert_equal 1, zone.locations.count
    assert_equal 0, zone.elements.count
    assert_equal storage, zone.storages.first

    assert_equal 0, storage.locations.count
    assert_equal 1, storage.elements.count
    assert_equal zone, storage.zones.first
  end

  test "should attach zone to storage with next index" do
    storage = storages(:masters)

    zone = Zone.new kind: :hold, index_position: storage.zones.count
    assert zone.save
    assert zone.locate_to storage

    new_zone = Zone.new kind: :ship, index_position: storage.zones.count
    assert new_zone.save
    assert new_zone.locate_to storage

    assert_equal 2, storage.zones.count

    assert_equal "A", storage.zones.first.display_index
    assert_equal "B", storage.zones.last.display_index
  end

  test "should attach line to zone" do
    zone = zones(:goods_zone)

    assert_difference "zone.lines.count", 2 do
      assert Line.repeat 2, zone
    end
  end
end
