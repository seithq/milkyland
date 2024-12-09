require "application_system_test_case"

class Finance::AccountTransfersTest < ApplicationSystemTestCase
  setup do
    prepare_articles
    sign_in "daniyar@hey.com"
  end

  test "should create account transfer" do
    visit transactions_url
    click_on I18n.t("actions.create_account_transfer")

    select bank_accounts(:milkyland_account).name, from: "transaction_source_account_id"
    select bank_accounts(:blank_account).name, from: "transaction_destination_account_id"
    fill_in "transaction_amount", with: 20000.0
    click_on I18n.t("actions.save_record")

    assert_text I18n.t("actions.record_created")
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
