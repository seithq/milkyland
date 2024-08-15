require "test_helper"

class StandardTest < ActiveSupport::TestCase
  test "should validate presence of name" do
    standard = Standard.new(group: groups(:milk25), from: 0, to: 100)
    assert_not standard.save
    assert_equal :blank, standard.errors.where(:name).first.type
  end

  test "should validate uniqueness of name" do
    standard = Standard.new(group: groups(:milk25), from: 0, to: 100, name: standards(:acidity).name)
    assert_not standard.save
    assert_equal :taken, standard.errors.where(:name).first.type
  end

  test "should validate presence of from and to" do
    standard = Standard.new(group: groups(:milk25), name: "New Record")
    assert_not standard.save
    assert_equal :blank, standard.errors.where(:from).first.type
    assert_equal :blank, standard.errors.where(:to).first.type
  end

  test "should validate numericality of from and to" do
    standard = Standard.new(group: groups(:milk25), from: "A", to: "B", name: "New Record")
    assert_not standard.save
    assert_equal :not_a_number, standard.errors.where(:from).first.type
    assert_equal :not_a_number, standard.errors.where(:to).first.type
  end

  test "should check value between values in range" do
    standard = standards(:acidity)
    assert standard.passed? standard.from
    assert standard.passed? standard.to
  end

  test "should create standard without errors" do
    standard = Standard.new(group: groups(:milk25), from: 0, to: 100, name: "GOST", measurement: measurements(:kilogram))
    assert standard.save
  end
end
