class UpdateSupplyOrderPaymentStatusJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    Rails.logger.error("UpdateSupplyOrderPaymentStatusJob: #{exception.message}")
  end

  def perform(transaction_id)
    transaction = Transaction.find(transaction_id)

    # Если не исполнен
    return false unless transaction.completed?

    # Если нет связки с заказом ТМЦ
    return true unless transaction.supply_order.present?

    # Если статус заказа как оплачен
    return true if transaction.supply_order.paid?

    transaction.transaction do
      transaction.supply_order.update! payment_status: :paid
    end

    true
  rescue ActiveRecord::RecordInvalid => exception
    Rails.logger.error("UpdateSupplyOrderPaymentStatusJob: #{exception.message}")
    false
  end
end
