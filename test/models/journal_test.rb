require "test_helper"

class JournalTest < ActiveSupport::TestCase
  test "should validate presence of name" do
    journal = Journal.new(group: groups(:milk25))
    assert_not journal.save
    assert_equal :blank, journal.errors.where(:name).first.type
  end

  test "should validate uniqueness of name" do
    journal = Journal.new(group: groups(:milk25), name: journals(:skimming).name)
    assert_not journal.save
    assert_equal :taken, journal.errors.where(:name).first.type
  end

  test "should create a new journal and group" do
    group = Group.new(name: "Milk 5%", metric_tonne: 1, category: categories(:milk))
    assert group.save

    journal = Journal.new(group: group, name: journals(:skimming).name)
    assert journal.save
  end
end
