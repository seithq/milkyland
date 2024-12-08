require "application_system_test_case"

class TransactionsTest < ApplicationSystemTestCase
  setup do
    @transaction = transactions(:one)
  end

  test "visiting the index" do
    visit transactions_url
    assert_selector "h1", text: "Transactions"
  end

  test "should create transaction" do
    visit transactions_url
    click_on "New transaction"

    fill_in "Amount", with: @transaction.amount
    fill_in "Article", with: @transaction.article_id
    fill_in "Bank account", with: @transaction.bank_account_id
    fill_in "Client", with: @transaction.client_id
    fill_in "Comment", with: @transaction.comment
    fill_in "Creator", with: @transaction.creator_id
    fill_in "Execution date", with: @transaction.execution_date
    fill_in "Kind", with: @transaction.kind
    fill_in "Material asset", with: @transaction.material_asset_id
    fill_in "Planned date", with: @transaction.planned_date
    fill_in "Status", with: @transaction.status
    click_on "Create Transaction"

    assert_text "Transaction was successfully created"
    click_on "Back"
  end

  test "should update Transaction" do
    visit transaction_url(@transaction)
    click_on "Edit this transaction", match: :first

    fill_in "Amount", with: @transaction.amount
    fill_in "Article", with: @transaction.article_id
    fill_in "Bank account", with: @transaction.bank_account_id
    fill_in "Client", with: @transaction.client_id
    fill_in "Comment", with: @transaction.comment
    fill_in "Creator", with: @transaction.creator_id
    fill_in "Execution date", with: @transaction.execution_date
    fill_in "Kind", with: @transaction.kind
    fill_in "Material asset", with: @transaction.material_asset_id
    fill_in "Planned date", with: @transaction.planned_date
    fill_in "Status", with: @transaction.status
    click_on "Update Transaction"

    assert_text "Transaction was successfully updated"
    click_on "Back"
  end

  test "should destroy Transaction" do
    visit transaction_url(@transaction)
    click_on "Destroy this transaction", match: :first

    assert_text "Transaction was successfully destroyed"
  end
end
