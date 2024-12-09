require "test_helper"

class Finance::AccountTransfersControllerTest < ActionDispatch::IntegrationTest
  setup do
    prepare_articles
    sign_in :daniyar
  end

  test "should get new" do
    get new_account_transfer_url
    assert_response :success
  end

  test "should create account transfer" do
    assert_difference("Transaction.count", 2) do
      post account_transfers_url, params: { transaction: { source_account_id: bank_accounts(:milkyland_account).id, destination_account_id: bank_accounts(:blank_account).id, amount: 10000.0 } }
    end

    assert_redirected_to transactions_url
  end

  private
    def prepare_articles
      income_category = FinancialCategory.new kind: :income, name: "Transfer Income"
      assert income_category.save

      destination_article = Article.new kind: :income,
                                        activity_type: activity_types(:operational),
                                        financial_category: income_category,
                                        name: "Transfer Income Article",
                                        system: true
      assert destination_article.save

      expense_category = FinancialCategory.new kind: :expense, name: "Transfer Expense"
      assert expense_category.save

      source_article = Article.new kind: :expense,
                                   activity_type: activity_types(:operational),
                                   financial_category: expense_category,
                                   name: "Transfer Expense Article",
                                   system: true
      assert source_article.save
    end
end
