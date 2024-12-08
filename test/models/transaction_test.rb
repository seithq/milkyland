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

  test "should validate value of execution date" do
    transaction = Transaction.new kind: :expense,
                                  creator: users(:finance_operator),
                                  bank_account: bank_accounts(:milkyland_account),
                                  article: articles(:operational_expense_material_asset),
                                  material_asset: material_assets(:sugar),
                                  amount: 100000.0,
                                  status: :confirmed,
                                  planned_date: Date.today,
                                  execution_date: 1.day.ago
    assert transaction.invalid?
    assert_equal :greater_than_or_equal_to, transaction.errors.where(:execution_date).first.type
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
end
