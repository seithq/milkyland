require "application_system_test_case"

class SuppliersTest < ApplicationSystemTestCase
  setup do
    @supplier = suppliers(:one)
  end

  test "visiting the index" do
    visit suppliers_url
    assert_selector "h1", text: "Suppliers"
  end

  test "should create supplier" do
    visit suppliers_url
    click_on "New supplier"

    fill_in "Bank account", with: @supplier.bank_account
    fill_in "Bank code", with: @supplier.bank_code
    fill_in "Bank name", with: @supplier.bank_name
    fill_in "Bin", with: @supplier.bin
    fill_in "Contact person", with: @supplier.contact_person
    fill_in "Email address", with: @supplier.email_address
    fill_in "Entity code", with: @supplier.entity_code
    fill_in "Job title", with: @supplier.job_title
    fill_in "Name", with: @supplier.name
    fill_in "Phone number", with: @supplier.phone_number
    fill_in "User", with: @supplier.user_id
    click_on "Create Supplier"

    assert_text "Supplier was successfully created"
    click_on "Back"
  end

  test "should update Supplier" do
    visit supplier_url(@supplier)
    click_on "Edit this supplier", match: :first

    fill_in "Bank account", with: @supplier.bank_account
    fill_in "Bank code", with: @supplier.bank_code
    fill_in "Bank name", with: @supplier.bank_name
    fill_in "Bin", with: @supplier.bin
    fill_in "Contact person", with: @supplier.contact_person
    fill_in "Email address", with: @supplier.email_address
    fill_in "Entity code", with: @supplier.entity_code
    fill_in "Job title", with: @supplier.job_title
    fill_in "Name", with: @supplier.name
    fill_in "Phone number", with: @supplier.phone_number
    fill_in "User", with: @supplier.user_id
    click_on "Update Supplier"

    assert_text "Supplier was successfully updated"
    click_on "Back"
  end

  test "should destroy Supplier" do
    visit supplier_url(@supplier)
    click_on "Destroy this supplier", match: :first

    assert_text "Supplier was successfully destroyed"
  end
end
