require "application_system_test_case"

class PackagedProductsTest < ApplicationSystemTestCase
  setup do
    @packaged_product = packaged_products(:one)
  end

  test "visiting the index" do
    visit packaged_products_url
    assert_selector "h1", text: "Packaged products"
  end

  test "should create packaged product" do
    visit packaged_products_url
    click_on "New packaged product"

    fill_in "Count", with: @packaged_product.count
    fill_in "End time", with: @packaged_product.end_time
    fill_in "Packing", with: @packaged_product.packing_id
    fill_in "Product", with: @packaged_product.product_id
    fill_in "Start time", with: @packaged_product.start_time
    click_on "Create Packaged product"

    assert_text "Packaged product was successfully created"
    click_on "Back"
  end

  test "should update Packaged product" do
    visit packaged_product_url(@packaged_product)
    click_on "Edit this packaged product", match: :first

    fill_in "Count", with: @packaged_product.count
    fill_in "End time", with: @packaged_product.end_time.to_s
    fill_in "Packing", with: @packaged_product.packing_id
    fill_in "Product", with: @packaged_product.product_id
    fill_in "Start time", with: @packaged_product.start_time.to_s
    click_on "Update Packaged product"

    assert_text "Packaged product was successfully updated"
    click_on "Back"
  end

  test "should destroy Packaged product" do
    visit packaged_product_url(@packaged_product)
    click_on "Destroy this packaged product", match: :first

    assert_text "Packaged product was successfully destroyed"
  end
end
