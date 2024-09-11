require "test_helper"

class BatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @batch = batches(:one)
  end

  test "should get index" do
    get batches_url
    assert_response :success
  end

  test "should get new" do
    get new_batch_url
    assert_response :success
  end

  test "should create batch" do
    assert_difference("Batch.count") do
      post batches_url, params: { batch: { comment: @batch.comment, loader_id: @batch.loader_id, machiner_id: @batch.machiner_id, operator_id: @batch.operator_id, production_unit_id: @batch.production_unit_id, status: @batch.status, tester_id: @batch.tester_id } }
    end

    assert_redirected_to batch_url(Batch.last)
  end

  test "should show batch" do
    get batch_url(@batch)
    assert_response :success
  end

  test "should get edit" do
    get edit_batch_url(@batch)
    assert_response :success
  end

  test "should update batch" do
    patch batch_url(@batch), params: { batch: { comment: @batch.comment, loader_id: @batch.loader_id, machiner_id: @batch.machiner_id, operator_id: @batch.operator_id, production_unit_id: @batch.production_unit_id, status: @batch.status, tester_id: @batch.tester_id } }
    assert_redirected_to batch_url(@batch)
  end

  test "should destroy batch" do
    assert_difference("Batch.count", -1) do
      delete batch_url(@batch)
    end

    assert_redirected_to batches_url
  end
end
