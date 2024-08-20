require "test_helper"

class PackingMachineTest < ActiveSupport::TestCase
  test "should validate presence of name" do
    machine = PackingMachine.new
    assert_not machine.save
    assert_equal :blank, machine.errors.where(:name).first.type
  end

  test "should validate uniqueness of name" do
    machine = PackingMachine.new(name: packing_machines(:bottler).name)
    assert_not machine.save
    assert_equal :taken, machine.errors.where(:name).first.type
  end
end
