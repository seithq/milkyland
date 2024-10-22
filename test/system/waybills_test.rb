require "application_system_test_case"

class WaybillsTest < ApplicationSystemTestCase
  setup do
    @waybill = waybills(:one)
  end

  test "visiting the index" do
    visit waybills_url
    assert_selector "h1", text: "Waybills"
  end

  test "should create waybill" do
    visit waybills_url
    click_on "New waybill"

    fill_in "Comment", with: @waybill.comment
    fill_in "Kind", with: @waybill.kind
    fill_in "New storage", with: @waybill.new_storage_id
    fill_in "Plan", with: @waybill.plan_id
    fill_in "Receiver", with: @waybill.receiver_id
    fill_in "Sender", with: @waybill.sender_id
    fill_in "Storage", with: @waybill.storage_id
    click_on "Create Waybill"

    assert_text "Waybill was successfully created"
    click_on "Back"
  end

  test "should update Waybill" do
    visit waybill_url(@waybill)
    click_on "Edit this waybill", match: :first

    fill_in "Comment", with: @waybill.comment
    fill_in "Kind", with: @waybill.kind
    fill_in "New storage", with: @waybill.new_storage_id
    fill_in "Plan", with: @waybill.plan_id
    fill_in "Receiver", with: @waybill.receiver_id
    fill_in "Sender", with: @waybill.sender_id
    fill_in "Storage", with: @waybill.storage_id
    click_on "Update Waybill"

    assert_text "Waybill was successfully updated"
    click_on "Back"
  end

  test "should destroy Waybill" do
    visit waybill_url(@waybill)
    click_on "Destroy this waybill", match: :first

    assert_text "Waybill was successfully destroyed"
  end
end
