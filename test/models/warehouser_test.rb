require "test_helper"

class WarehouserTest < ActiveSupport::TestCase
  test "should validate uniqueness of warehouser inside storage" do
    warehouser = Warehouser.new(storage: storages(:goods), user: users(:warehouser))
    assert warehouser.invalid?
    assert_equal :taken, warehouser.errors.where(:user_id).first.type
  end

  test "should validate presence replaceable" do
    warehouser = Warehouser.new(storage: storages(:goods), user: users(:warehouser), duty: :replacing)
    assert warehouser.invalid?
    assert_equal :blank, warehouser.errors.where(:replaceable_id).first.type
  end

  test "should clear replaceable" do
    warehouser = Warehouser.new(storage: storages(:goods), user: users(:daniyar), duty: :replacing, replaceable: users(:warehouser))
    assert warehouser.save
    assert warehouser.update duty: :executing
    assert warehouser.replaceable.blank?
  end
end
