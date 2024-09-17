require "application_system_test_case"

class PackingsTest < ApplicationSystemTestCase
  setup do
    @packing = packings(:one)
  end

  test "visiting the index" do
    visit packings_url
    assert_selector "h1", text: "Packings"
  end

  test "should create packing" do
    visit packings_url
    click_on "New packing"

    fill_in "Batch", with: @packing.batch_id
    fill_in "Status", with: @packing.status
    click_on "Create Packing"

    assert_text "Packing was successfully created"
    click_on "Back"
  end

  test "should update Packing" do
    visit packing_url(@packing)
    click_on "Edit this packing", match: :first

    fill_in "Batch", with: @packing.batch_id
    fill_in "Status", with: @packing.status
    click_on "Update Packing"

    assert_text "Packing was successfully updated"
    click_on "Back"
  end

  test "should destroy Packing" do
    visit packing_url(@packing)
    click_on "Destroy this packing", match: :first

    assert_text "Packing was successfully destroyed"
  end
end
