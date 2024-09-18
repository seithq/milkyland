require "application_system_test_case"

class DistributionsTest < ApplicationSystemTestCase
  setup do
    @distribution = distributions(:one)
  end

  test "visiting the index" do
    visit distributions_url
    assert_selector "h1", text: "Distributions"
  end

  test "should create distribution" do
    visit distributions_url
    click_on "New distribution"

    fill_in "Batch", with: @distribution.batch_id
    fill_in "Comment", with: @distribution.comment
    fill_in "Status", with: @distribution.status
    click_on "Create Distribution"

    assert_text "Distribution was successfully created"
    click_on "Back"
  end

  test "should update Distribution" do
    visit distribution_url(@distribution)
    click_on "Edit this distribution", match: :first

    fill_in "Batch", with: @distribution.batch_id
    fill_in "Comment", with: @distribution.comment
    fill_in "Status", with: @distribution.status
    click_on "Update Distribution"

    assert_text "Distribution was successfully updated"
    click_on "Back"
  end

  test "should destroy Distribution" do
    visit distribution_url(@distribution)
    click_on "Destroy this distribution", match: :first

    assert_text "Distribution was successfully destroyed"
  end
end
