require "test_helper"

class Settings::SuppliersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @supplier = suppliers(:systemd)
  end

  test "should get index" do
    sign_in :daniyar
    get suppliers_url
    assert_response :success
  end

  test "should get new" do
    sign_in :daniyar
    get new_supplier_url
    assert_response :success
  end

  test "should create supplier" do
    sign_in :daniyar
    assert_difference("Supplier.count") do
      post suppliers_url, params: { supplier: { bin: "921026400042", name: "REGATA", manager_id: users(:askhat).id } }
    end

    assert_redirected_to suppliers_url
  end

  test "create does not allow non-admins to create record" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    post suppliers_url, params: { supplier: { bin: "921026400042", name: "REGATA", manager_id: users(:askhat).id } }
    assert_response :forbidden
  end

  test "should show supplier" do
    sign_in :daniyar
    get supplier_url(@supplier)
    assert_response :success
  end

  test "should get edit" do
    sign_in :daniyar
    get edit_supplier_url(@supplier)
    assert_response :success
  end

  test "should update supplier" do
    sign_in :daniyar
    patch supplier_url(@supplier), params: { supplier: { contact_person: "Aigerim", email_address: "regata@mail.ru", phone_number: "+77772098007" } }
    assert_redirected_to suppliers_url
  end

  test "update does not allow non-admins to change roles" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    patch supplier_url(@supplier), params: { supplier: { contact_person: "Aigerim", email_address: "regata@mail.ru", phone_number: "+77772098007" } }
    assert_response :forbidden
  end
end
