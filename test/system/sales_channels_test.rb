require "application_system_test_case"

class SalesChannelsTest < ApplicationSystemTestCase
  setup do
    @sales_channel = sales_channels(:one)
  end

  test "visiting the index" do
    visit sales_channels_url
    assert_selector "h1", text: "Sales channels"
  end

  test "should create sales channel" do
    visit sales_channels_url
    click_on "New sales channel"

    click_on "Create Sales channel"

    assert_text "Sales channel was successfully created"
    click_on "Back"
  end

  test "should update Sales channel" do
    visit sales_channel_url(@sales_channel)
    click_on "Edit this sales channel", match: :first

    click_on "Update Sales channel"

    assert_text "Sales channel was successfully updated"
    click_on "Back"
  end

  test "should destroy Sales channel" do
    visit sales_channel_url(@sales_channel)
    click_on "Destroy this sales channel", match: :first

    assert_text "Sales channel was successfully destroyed"
  end
end
