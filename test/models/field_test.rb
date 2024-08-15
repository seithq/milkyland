require "test_helper"

class FieldTest < ActiveSupport::TestCase
  test "should validate presence of name" do
    field = Field.new(operation: operations(:analysis))
    assert_not field.save
    assert_equal :blank, field.errors.where(:name).first.type
  end

  test "should validate uniqueness of name" do
    field = Field.new(operation: operations(:analysis), name: fields(:start_time).name)
    assert_not field.save
    assert_equal :taken, field.errors.where(:name).first.type
  end

  test "should create a new operation and group" do
    group = Group.new(name: "Milk 5%", metric_tonne: 1, category: categories(:milk))
    assert group.save

    journal = Journal.new(group: group, name: journals(:skimming).name)
    assert journal.save

    operation = Operation.new(journal: journal, name: operations(:analysis).name)
    assert operation.save

    field = Field.new(operation: operation, name: fields(:start_time).name)
    assert field.save
  end
end
