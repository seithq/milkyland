require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  test "should validate presence of planned date" do
    transaction = Transaction.new kind: :income,
                                  creator: users(:finance_operator),
                                  bank_account: bank_accounts(:milkyland_account),
                                  article: articles(:operational_income_client),
                                  client: clients(:systemd),
                                  amount: 100000.0,
                                  status: :completed
    assert transaction.invalid?
    assert_equal :blank, transaction.errors.where(:planned_date).first.type
  end

  test "should validate value of planned date" do
    transaction = Transaction.new kind: :income,
                                  creator: users(:finance_operator),
                                  bank_account: bank_accounts(:milkyland_account),
                                  article: articles(:operational_income_client),
                                  client: clients(:systemd),
                                  amount: 100000.0,
                                  status: :completed,
                                  planned_date: 1.day.ago
    assert transaction.invalid?
    assert_equal :greater_than_or_equal_to, transaction.errors.where(:planned_date).first.type
  end

  test "should validate presence of execution date" do
    transaction = Transaction.new kind: :income,
                                  creator: users(:finance_operator),
                                  bank_account: bank_accounts(:milkyland_account),
                                  article: articles(:operational_income_client),
                                  client: clients(:systemd),
                                  amount: 100000.0,
                                  status: :completed,
                                  planned_date: Date.current
    assert transaction.invalid?
    assert_equal :blank, transaction.errors.where(:execution_date).first.type
  end

  test "should upgrade status if needed for income" do
    transaction = Transaction.new kind: :income,
                                  creator: users(:finance_operator),
                                  bank_account: bank_accounts(:milkyland_account),
                                  article: articles(:operational_income_client),
                                  client: clients(:systemd),
                                  amount: 100000.0,
                                  status: :pending,
                                  planned_date: Date.current
    assert transaction.save
    assert transaction.reload.confirmed?
  end

  test "should upgrade status if needed for expense by min amount" do
    article = articles(:operational_expense_material_asset)
    assert article.update min_amount: 200000.0

    transaction = Transaction.new kind: :expense,
                                  creator: users(:finance_operator),
                                  bank_account: bank_accounts(:milkyland_account),
                                  article: article,
                                  material_asset: material_assets(:sugar),
                                  amount: 100000.0,
                                  status: :pending,
                                  planned_date: Date.today
    assert transaction.save
    assert transaction.reload.confirmed?
  end

  test "should upgrade status if needed for expense by bypass flag" do
    article = articles(:operational_expense_material_asset)
    assert article.update bypass_control: true

    transaction = Transaction.new kind: :expense,
                                  creator: users(:finance_operator),
                                  bank_account: bank_accounts(:milkyland_account),
                                  article: article,
                                  material_asset: material_assets(:sugar),
                                  amount: 100000.0,
                                  status: :pending,
                                  planned_date: Date.today
    assert transaction.save
    assert transaction.reload.confirmed?
  end

  test "should create transfer" do
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

    source_account, destination_account = bank_accounts(:milkyland_account), bank_accounts(:blank_account)

    assert_difference "Transaction.count", 2 do
      expense_trx, income_trx = Transaction.transfer users(:daniyar).id,
                                                     source_account.id,
                                                     destination_account.id,
                                                     20000.0,
                                                     source_article.id,
                                                     destination_article.id
      assert_equal expense_trx, income_trx.linked_transaction
      assert_equal income_trx, expense_trx.linked_transaction
    end
  end
end
