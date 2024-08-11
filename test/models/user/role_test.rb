require "test_helper"

class User::RoleTest < ActiveSupport::TestCase
  test "creating users makes them managers by default" do
    assert User.create!(name: "User", email_address: "user@example.com", password: "secret123456").manager?
  end

  test "can_administer?" do
    assert User.new(role: :admin).can_administer?

    assert_not User.new(role: :manager).can_administer?
    assert_not User.new.can_administer?
  end
end
