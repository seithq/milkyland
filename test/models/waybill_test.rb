require "test_helper"

class WaybillTest < ActiveSupport::TestCase
  test "should validate presence of storage" do
    waybill = Waybill.new(kind: :transfer, new_storage: storages(:material_assets_reserve), sender: users(:daniyar))
    assert waybill.invalid?
    assert_equal :blank, waybill.errors.where(:storage_id).first.type
  end

  test "should validate presence of new storage" do
    waybill = Waybill.new(kind: :arrival, sender: users(:daniyar))
    assert waybill.invalid?
    assert_equal :blank, waybill.errors.where(:new_storage_id).first.type
  end

  test "should validate presence of batch" do
    waybill = Waybill.new(kind: :production_write_off, storage: storages(:material_assets))
    assert waybill.invalid?
    assert_equal :blank, waybill.errors.where(:batch_id).first.type
  end

  test "should validate storage integrity" do
    waybill = waybills(:assets_transfer)
    assert_not waybill.update(new_storage: storages(:material_assets))
    assert_equal :inclusion, waybill.errors.where(:new_storage_id).first.type
  end

  test "should validate scope for material_assets" do
    waybills = Waybill.for_material_assets
    assert_equal 3, waybills.count
  end
end
