require "test_helper"

class GroupTest < ActiveSupport::TestCase
  test "should copy group" do
    group = groups(:milk25)
    copy = group.copy
    assert copy.save
  end
end
