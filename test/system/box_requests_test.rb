require "application_system_test_case"

class BoxRequestsTest < ApplicationSystemTestCase
  setup do
    @box_request = box_requests(:one)
  end

  test "visiting the index" do
    visit box_requests_url
    assert_selector "h1", text: "Box requests"
  end

  test "should create box request" do
    visit box_requests_url
    click_on "New box request"

    fill_in "Count", with: @box_request.count
    fill_in "Generation", with: @box_request.generation_id
    click_on "Create Box request"

    assert_text "Box request was successfully created"
    click_on "Back"
  end

  test "should update Box request" do
    visit box_request_url(@box_request)
    click_on "Edit this box request", match: :first

    fill_in "Count", with: @box_request.count
    fill_in "Generation", with: @box_request.generation_id
    click_on "Update Box request"

    assert_text "Box request was successfully updated"
    click_on "Back"
  end

  test "should destroy Box request" do
    visit box_request_url(@box_request)
    click_on "Destroy this box request", match: :first

    assert_text "Box request was successfully destroyed"
  end
end
