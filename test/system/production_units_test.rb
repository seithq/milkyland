require "application_system_test_case"

class ProductionUnitsTest < ApplicationSystemTestCase
  setup do
    @production_unit = production_units(:one)
  end

  test "visiting the index" do
    visit production_units_url
    assert_selector "h1", text: "Production units"
  end

  test "should create production unit" do
    visit production_units_url
    click_on "New production unit"

    fill_in "Comment", with: @production_unit.comment
    fill_in "Count", with: @production_unit.count
    fill_in "Group", with: @production_unit.group_id
    fill_in "Plan", with: @production_unit.plan_id
    fill_in "Status", with: @production_unit.status
    fill_in "Tonnage", with: @production_unit.tonnage
    click_on "Create Production unit"

    assert_text "Production unit was successfully created"
    click_on "Back"
  end

  test "should update Production unit" do
    visit production_unit_url(@production_unit)
    click_on "Edit this production unit", match: :first

    fill_in "Comment", with: @production_unit.comment
    fill_in "Count", with: @production_unit.count
    fill_in "Group", with: @production_unit.group_id
    fill_in "Plan", with: @production_unit.plan_id
    fill_in "Status", with: @production_unit.status
    fill_in "Tonnage", with: @production_unit.tonnage
    click_on "Update Production unit"

    assert_text "Production unit was successfully updated"
    click_on "Back"
  end

  test "should destroy Production unit" do
    visit production_unit_url(@production_unit)
    click_on "Destroy this production unit", match: :first

    assert_text "Production unit was successfully destroyed"
  end
end
