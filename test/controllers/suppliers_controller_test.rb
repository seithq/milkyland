require "test_helper"

class SuppliersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @supplier = suppliers(:one)
  end

  test "should get index" do
    get suppliers_url
    assert_response :success
  end

  test "should get new" do
    get new_supplier_url
    assert_response :success
  end

  test "should create supplier" do
    assert_difference("Supplier.count") do
      post suppliers_url, params: { supplier: { bank_account: @supplier.bank_account, bank_code: @supplier.bank_code, bank_name: @supplier.bank_name, bin: @supplier.bin, contact_person: @supplier.contact_person, email_address: @supplier.email_address, entity_code: @supplier.entity_code, job_title: @supplier.job_title, name: @supplier.name, phone_number: @supplier.phone_number, user_id: @supplier.user_id } }
    end

    assert_redirected_to supplier_url(Supplier.last)
  end

  test "should show supplier" do
    get supplier_url(@supplier)
    assert_response :success
  end

  test "should get edit" do
    get edit_supplier_url(@supplier)
    assert_response :success
  end

  test "should update supplier" do
    patch supplier_url(@supplier), params: { supplier: { bank_account: @supplier.bank_account, bank_code: @supplier.bank_code, bank_name: @supplier.bank_name, bin: @supplier.bin, contact_person: @supplier.contact_person, email_address: @supplier.email_address, entity_code: @supplier.entity_code, job_title: @supplier.job_title, name: @supplier.name, phone_number: @supplier.phone_number, user_id: @supplier.user_id } }
    assert_redirected_to supplier_url(@supplier)
  end

  test "should destroy supplier" do
    assert_difference("Supplier.count", -1) do
      delete supplier_url(@supplier)
    end

    assert_redirected_to suppliers_url
  end
end
