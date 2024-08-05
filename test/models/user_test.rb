require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user does not prevent very long passwords" do
    users(:daniyar).update(password: "secret" * 50)
    assert users(:daniyar).valid?
  end
end
