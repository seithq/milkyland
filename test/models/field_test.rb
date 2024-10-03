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

  test "should validate presence of measurement id" do
    field = Field.new(operation: operations(:analysis), kind: :measure, name: "Test Name")
    assert_not field.save
    assert_equal :blank, field.errors.where(:measurement_id).first.type
  end

  test "should discard trigger if not time" do
    field = Field.new(
      operation: operations(:analysis),
      kind: :date,
      name: "Test Date",
      trigger: :on_start
    )
    assert field.save
    assert field.trigger_on_save?
  end

  test "should discard trackable if not on stop" do
    field = Field.new(
      operation: operations(:analysis),
      kind: :time,
      name: "Test Time",
      trigger: :on_save,
      trackable: fields(:start_time)
    )
    assert field.save
    assert field.trackable.blank?
  end

  test "should save trackable" do
    start_field = fields(:start_time)
    assert start_field.update trigger: :on_start

    end_field = Field.new(
      operation: operations(:analysis),
      kind: :time,
      name: "End Time",
      trigger: :on_stop,
      trackable: fields(:start_time)
    )
    assert end_field.save
    assert end_field.trackable.present?
  end
end
