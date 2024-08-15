require "test_helper"

class OperationTest < ActiveSupport::TestCase
  test "should validate presence of name" do
    operation = Operation.new(journal: journals(:skimming))
    assert_not operation.save
    assert_equal :blank, operation.errors.where(:name).first.type
  end

  test "should validate uniqueness of name" do
    operation = Operation.new(journal: journals(:skimming), name: operations(:analysis).name)
    assert_not operation.save
    assert_equal :taken, operation.errors.where(:name).first.type
  end

  test "should create a new operation and group" do
    group = Group.new(name: "Milk 5%", metric_tonne: 1, category: categories(:milk))
    assert group.save

    journal = Journal.new(group: group, name: journals(:skimming).name)
    assert journal.save

    operation = Operation.new(journal: journal, name: operations(:analysis).name)
    assert operation.save
  end
end
