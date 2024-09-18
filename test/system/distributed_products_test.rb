require "application_system_test_case"

class DistributedProductsTest < ApplicationSystemTestCase
  setup do
    @distributed_product = distributed_products(:one)
  end

  test "visiting the index" do
    visit distributed_products_url
    assert_selector "h1", text: "Distributed products"
  end

  test "should create distributed product" do
    visit distributed_products_url
    click_on "New distributed product"

    fill_in "Count", with: @distributed_product.count
    fill_in "Distribution", with: @distributed_product.distribution_id
    fill_in "Packaged product", with: @distributed_product.packaged_product_id
    fill_in "Production date", with: @distributed_product.production_date
    fill_in "Region", with: @distributed_product.region_id
    click_on "Create Distributed product"

    assert_text "Distributed product was successfully created"
    click_on "Back"
  end

  test "should update Distributed product" do
    visit distributed_product_url(@distributed_product)
    click_on "Edit this distributed product", match: :first

    fill_in "Count", with: @distributed_product.count
    fill_in "Distribution", with: @distributed_product.distribution_id
    fill_in "Packaged product", with: @distributed_product.packaged_product_id
    fill_in "Production date", with: @distributed_product.production_date
    fill_in "Region", with: @distributed_product.region_id
    click_on "Update Distributed product"

    assert_text "Distributed product was successfully updated"
    click_on "Back"
  end

  test "should destroy Distributed product" do
    visit distributed_product_url(@distributed_product)
    click_on "Destroy this distributed product", match: :first

    assert_text "Distributed product was successfully destroyed"
  end
end
