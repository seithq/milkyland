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

    zone = Zone.new kind: :hold, index_position: storage.zones.count
    assert zone.save

    assert zone.locate_to storage

    assert_equal 1, zone.locations.count
    assert_equal 0, zone.elements.count
    assert_equal storage, zone.storages.first

    assert_equal 0, storage.locations.count
    assert_equal 2, storage.elements.count
    assert_equal zone, storage.zones.ordered.last
  end

  test "should attach zone to storage with next index" do
    storage = storages(:masters)

    zone = Zone.new kind: :hold, index_position: storage.zones.count
    assert zone.save
    assert zone.locate_to storage

    new_zone = Zone.new kind: :ship, index_position: storage.zones.count
    assert new_zone.save
    assert new_zone.locate_to storage

    assert_equal 3, storage.zones.count

    assert_equal "A", storage.zones.first.display_index
    assert_equal "B", storage.zones.second.display_index
    assert_equal "C", storage.zones.last.display_index
  end

  test "should attach line to zone" do
    zone = zones(:goods_zone)

    assert_difference "zone.lines.count", 2 do
      assert Line.repeat 2, zone
    end
  end

  test "should attach stack to line" do
    line = lines(:goods_zone_line)

    assert_difference "line.stacks.count", 2 do
      assert Stack.repeat 2, line
    end
  end

  test "should attach tier to stack" do
    stack = stacks(:goods_zone_line_stack)

    assert_difference "stack.tiers.count", 2 do
      assert Tier.repeat 2, stack
    end
  end

  test "should check zone for storables" do
    zone = zones(:goods_zone)
    assert_equal 1, zone.lines.count
    assert_equal 1, zone.stacks.count
    assert_equal 1, zone.tiers.count
  end

  test "should find products inside zones" do
    product = products(:milk25)

    zone = zones(:goods_zone)

    pallet = Pallet.new
    assert pallet.save

    box = Box.new(region: regions(:almaty),
                  product: product,
                  production_date: Date.current,
                  expiration_date: Date.tomorrow,
                  capacity: 5)
    assert box.save
    assert box.locate_to pallet

    tier = tiers(:goods_zone_line_stack_tier)
    assert pallet.locate_to tier

    assert_equal 0, tier.boxes.count
    assert_equal 1, tier.boxes_in_pallets.count
    assert_equal 1, tier.pallets.count
    assert_equal 5, tier.capacity_by(product.id)

    assert_equal 0, zone.boxes.count
    assert_equal 1, zone.boxes_in_tiers_in_pallets.count
    assert_equal 1, zone.pallets_in_tiers.count
    assert_equal 5, zone.capacity_by(product.id)
  end

  test "should validate hierarchy level" do
    pallet = Pallet.new
    assert pallet.save

    stack = stacks(:goods_zone_line_stack)

    assert_raise ActiveRecord::RecordInvalid do
      pallet.locate_to stack
    end
  end

  test "should validate type integrity" do
    pallet = Pallet.new
    assert pallet.save

    positionable_pallet = Pallet.new
    assert positionable_pallet.save

    assert_raise ActiveRecord::RecordInvalid do
      pallet.locate_to positionable_pallet
    end
  end
end
