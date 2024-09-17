require "test_helper"

class PackingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @packing = packings(:one)
  end

  test "should get index" do
    get packings_url
    assert_response :success
  end

  test "should get new" do
    get new_packing_url
    assert_response :success
  end

  test "should create packing" do
    assert_difference("Packing.count") do
      post packings_url, params: { packing: { batch_id: @packing.batch_id, status: @packing.status } }
    end

    assert_redirected_to packing_url(Packing.last)
  end

  test "should show packing" do
    get packing_url(@packing)
    assert_response :success
  end

  test "should get edit" do
    get edit_packing_url(@packing)
    assert_response :success
  end

  test "should update packing" do
    patch packing_url(@packing), params: { packing: { batch_id: @packing.batch_id, status: @packing.status } }
    assert_redirected_to packing_url(@packing)
  end

  test "should destroy packing" do
    assert_difference("Packing.count", -1) do
      delete packing_url(@packing)
    end

    assert_redirected_to packings_url
  end
end
