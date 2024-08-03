require "test_helper"

class FirstRunTest < ActiveSupport::TestCase
  setup do
    Account.destroy_all
  end

  test "creating makes first user an administrator" do
    user = create_first_run_user
    assert user.admin?
  end

  test "creates an account" do
    assert_changes -> { Account.count }, +1 do
      create_first_run_user
    end
  end

  private
    def create_first_run_user
      FirstRun.create!({ name: "User", email_address: "user@example.com", password: "secret123456" })
    end
end
