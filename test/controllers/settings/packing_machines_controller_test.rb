require "test_helper"

class Settings::PackingMachinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @packing_machine = packing_machines(:bottler)
  end

  test "should get index" do
    sign_in :daniyar
    get packing_machines_url
    assert_response :success
  end

  test "should get new" do
    sign_in :daniyar
    get new_packing_machine_url
    assert_response :success
  end

  test "should create packing_machine" do
    sign_in :daniyar
    assert_difference("PackingMachine.count") do
      post packing_machines_url, params: { packing_machine: { name: "New Machine" } }
    end

    assert_redirected_to edit_packing_machine_url(PackingMachine.last)
  end

  test "create does not allow non-admins to create record" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    post packing_machines_url, params: { packing_machine: { name: "New Machine" } }
    assert_response :forbidden
  end

  test "should show packing_machine" do
    sign_in :daniyar
    get packing_machine_url(@packing_machine)
    assert_response :success
  end

  test "should get edit" do
    sign_in :daniyar
    get edit_packing_machine_url(@packing_machine)
    assert_response :success
  end

  test "should update packing_machine" do
    sign_in :daniyar
    patch packing_machine_url(@packing_machine), params: { packing_machine: { name: "New Machine" } }
    assert_redirected_to packing_machines_url
  end

  test "update does not allow non-admins to change roles" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    patch packing_machine_url(@packing_machine), params: { packing_machine: { name: "New Machine" } }
    assert_response :forbidden
  end
end
