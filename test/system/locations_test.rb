require "application_system_test_case"

class LocationsTest < ApplicationSystemTestCase
  setup do
    @location = locations(:one)
  end

  test "visiting the index" do
    visit locations_url
    assert_selector "h1", text: "Locations"
  end

  test "should create location" do
    visit locations_url
    click_on "New location"

    check "Active" if @location.active
    fill_in "Position", with: @location.position_id
    fill_in "Position type", with: @location.position_type
    fill_in "Storable", with: @location.storable_id
    fill_in "Storable type", with: @location.storable_type
    click_on "Create Location"

    assert_text "Location was successfully created"
    click_on "Back"
  end

  test "should update Location" do
    visit location_url(@location)
    click_on "Edit this location", match: :first

    check "Active" if @location.active
    fill_in "Position", with: @location.position_id
    fill_in "Position type", with: @location.position_type
    fill_in "Storable", with: @location.storable_id
    fill_in "Storable type", with: @location.storable_type
    click_on "Update Location"

    assert_text "Location was successfully updated"
    click_on "Back"
  end

  test "should destroy Location" do
    visit location_url(@location)
    click_on "Destroy this location", match: :first

    assert_text "Location was successfully destroyed"
  end
end
