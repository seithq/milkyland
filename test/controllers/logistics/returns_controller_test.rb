require "test_helper"

class Logistics::ReturnsControllerTest < ActionDispatch::IntegrationTest
  setup do
    create_return_for_departure
    sign_in :daniyar
  end

  test "should get index" do
    get returns_url
    assert_response :success
  end

  test "should get new" do
    get new_return_url
    assert_response :success
  end

  test "should create return" do
    assert_difference("Return.count") do
      post returns_url, params: { return: { comment: "TEST", order_id: orders(:opening).id, storage_id: storages(:goods).id } }
    end

    assert_redirected_to returns_url
  end

  test "should show return" do
    get return_url(@return)
    assert_response :success
  end

  test "should get edit" do
    get edit_return_url(@return)
    assert_response :success
  end

  test "should update return" do
    patch return_url(@return), params: { return: { comment: "TEST" } }
    assert_redirected_to returns_url
  end

  test "should destroy return" do
    assert_difference("Return.count", -1) do
      delete return_url(@return)
    end

    assert_redirected_to returns_url
  end

  private
    def create_return_for_departure
      @waybill = Waybill.new kind: :departure,
                             status: :approved,
                             order: orders(:opening),
                             storage: storages(:goods),
                             sender: users(:daniyar)
      assert @waybill.save
      assert @waybill.leftovers.create subject: products(:milk25), count: 6

      @return = Return.new user: users(:daniyar),
                           order: orders(:opening),
                           storage: storages(:goods)
      assert @return.save
    end
end
