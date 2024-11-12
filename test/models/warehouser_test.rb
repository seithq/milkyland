require "test_helper"

class WarehouserTest < ActiveSupport::TestCase
  test "should validate uniqueness of warehouser inside storage" do
    warehouser = Warehouser.new(storage: storages(:goods), user: users(:warehouser))
    assert warehouser.invalid?
    assert_equal :taken, warehouser.errors.where(:user_id).first.type
  end
end
