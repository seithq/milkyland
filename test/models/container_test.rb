require "test_helper"

class ContainerTest < ActiveSupport::TestCase
  test "should validate presence of required fields" do
    container = Container.new
    assert_not container.save
    assert_equal :blank, container.errors.where(:performance).first.type
    assert_equal :blank, container.errors.where(:losses_percentage).first.type
  end

  test "should validate numericality of required fields" do
    container = Container.new(performance: 0, losses_percentage: 0)
    assert_not container.save
    assert_equal :greater_than, container.errors.where(:performance).first.type
    assert_equal :greater_than, container.errors.where(:losses_percentage).first.type
  end

  test "should validate uniqueness if material asset" do
    container = Container.new(packing_machine_id: packing_machines(:bottler).id,
                              performance: 1000,
                              losses_percentage: 1,
                              material_asset_id: material_assets(:bottle).id)
    assert_not container.save
    assert_equal :taken, container.errors.where(:material_asset_id).first.type
  end
end
