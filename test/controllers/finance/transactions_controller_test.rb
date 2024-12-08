require "test_helper"

class Finance::TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @transaction = transactions(:income_client)
    sign_in :daniyar
  end

  test "should get index" do
    get transactions_url
    assert_response :success
  end

  test "should get new" do
    get new_transaction_url
    assert_response :success
  end

  test "should create transaction" do
    assert_difference("Transaction.count") do
      post transactions_url, params: { transaction: { amount: 10000, article_id: @transaction.article_id, bank_account_id: @transaction.bank_account_id, client_id: @transaction.client_id, kind: :income, planned_date: 1.day.from_now } }
    end

    assert_redirected_to transactions_url
  end

  test "should show transaction" do
    get transaction_url(@transaction)
    assert_response :success
  end

  test "should get edit" do
    get edit_transaction_url(@transaction)
    assert_response :success
  end

  test "should update transaction" do
    patch transaction_url(@transaction), params: { transaction: { comment: "Test" } }
    assert_redirected_to transactions_url
  end

  test "should destroy transaction" do
    assert_difference -> { Transaction.filter_by_status(:cancelled).count }, 1 do
      delete transaction_url(@transaction)
    end

    assert_redirected_to transactions_url
  end
end
