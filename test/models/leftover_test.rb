require "test_helper"

class LeftoverTest < ActiveSupport::TestCase
  test "should update negative count on parent change" do
    leftover = leftovers(:assets_transfer_in)
    assert leftover.update count: 1000.0
    assert_equal -1000.0, leftover.child.count
  end

  test "should delete negative on parent destroy" do
    leftover = leftovers(:assets_transfer_in)
    assert_difference("Leftover.count", -2) do
      assert leftover.destroy
    end
  end

  test "should create negative on parent create" do
    waybill = Waybill.new(kind: :transfer, storage: storages(:material_assets), new_storage: storages(:material_assets_reserve))
    assert waybill.save

    assert_difference("Leftover.count", 2) do
      parent = waybill.leftovers.new(subject_type: "MaterialAsset", subject_id: material_assets(:sugar).id, count: 5000)
      assert parent.save
    end

    assert_equal 5000, waybill.leftovers.positive.first.count
    assert_equal -5000, waybill.leftovers.negative.first.count
  end
end
