class GenerateTransactionForSupplyOrderJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    Rails.logger.error("GenerateTransactionForSupplyOrderJob: #{exception.message}")
  end

  def perform(supply_order_id, user_id)
    supply_order = SupplyOrder.find(supply_order_id)

    # Если не указан вендор в заказе. Это поле обязательное, не в БД. Отсюда и проверка
    return false unless supply_order.vendor.present?

    # Если нет счета по умолчанию
    accounts = BankAccount.main
    return false if accounts.empty?

    articles = Article.suppliables
    return false if articles.empty?

    supply_order.transaction do
      Transaction.create! kind: :expense,
                          bank_account_id: accounts.first.id,
                          article_id: articles.first.id,
                          contragent: supply_order.vendor.supplier,
                          amount: supply_order.total_amount,
                          planned_date: supply_order.payment_date,
                          material_asset_id: supply_order.material_asset_id,
                          creator_id: user_id,
                          supply_order_id: supply_order.id
    end

    true
  rescue ActiveRecord::RecordInvalid => exception
    Rails.logger.error("GenerateTransactionForSupplyOrderJob: #{exception.message}")
    false
  end
end
