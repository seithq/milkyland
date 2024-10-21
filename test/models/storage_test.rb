require "test_helper"

class StorageTest < ActiveSupport::TestCase
  test "should validate uniqueness of name" do
    storage = Storage.new(name: storages(:goods).name)
    assert storage.invalid?
    assert_equal :taken, storage.errors.where(:name).first.type
  end
end
