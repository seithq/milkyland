require "application_system_test_case"

class BoxPackagingsTest < ApplicationSystemTestCase
  setup do
    @box_packaging = box_packagings(:one)
  end

  test "visiting the index" do
    visit box_packagings_url
    assert_selector "h1", text: "Box packagings"
  end

  test "should create box packaging" do
    visit box_packagings_url
    click_on "New box packaging"

    fill_in "Count", with: @box_packaging.count
    fill_in "Material asset", with: @box_packaging.material_asset_id
    fill_in "Product", with: @box_packaging.product_id
    click_on "Create Box packaging"

    assert_text "Box packaging was successfully created"
    click_on "Back"
  end

  test "should update Box packaging" do
    visit box_packaging_url(@box_packaging)
    click_on "Edit this box packaging", match: :first

    fill_in "Count", with: @box_packaging.count
    fill_in "Material asset", with: @box_packaging.material_asset_id
    fill_in "Product", with: @box_packaging.product_id
    click_on "Update Box packaging"

    assert_text "Box packaging was successfully updated"
    click_on "Back"
  end

  test "should destroy Box packaging" do
    visit box_packaging_url(@box_packaging)
    click_on "Destroy this box packaging", match: :first

    assert_text "Box packaging was successfully destroyed"
  end
end
