require "test_helper"

class Settings::ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client = clients(:systemd)
  end

  test "should get index" do
    sign_in :daniyar
    get clients_url
    assert_response :success
  end

  test "should get new" do
    sign_in :daniyar
    get new_client_url
    assert_response :success
  end

  test "should create client" do
    sign_in :daniyar
    assert_difference("Client.count") do
      post clients_url, params: { client: { bin: "921026400042", name: "REGATA", manager_id: users(:askhat).id } }
    end

    assert_redirected_to edit_client_url(Client.last)
  end

  test "create does not allow non-admins to create record" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    post clients_url, params: { client: { bin: "921026400042", name: "REGATA", manager_id: users(:askhat).id } }
    assert_response :forbidden
  end

  test "should show client" do
    sign_in :daniyar
    get client_url(@client)
    assert_response :success
  end

  test "should get edit" do
    sign_in :daniyar
    get edit_client_url(@client)
    assert_response :success
  end

  test "should update client" do
    sign_in :daniyar
    patch client_url(@client), params: {
      client: { contact_person: "Aigerim",
                  email_address: "regata@mail.ru",
                  phone_number: "+77772098007",
                  uploads: [ file_fixture_upload("test.txt") ]
      }
    }
    assert_redirected_to clients_url
  end

  test "update does not allow non-admins to change roles" do
    sign_in :askhat
    assert_not users(:askhat).admin?

    patch client_url(@client), params: { client: { contact_person: "Aigerim", email_address: "regata@mail.ru", phone_number: "+77772098007" } }
    assert_response :forbidden
  end
end
