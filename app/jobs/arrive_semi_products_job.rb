class ArriveSemiProductsJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid) do |exception|
    Rails.logger.error("ArriveSemiProductsJob: #{exception.message}")
  end

  def perform(batch_id)
    batch = Batch.find(batch_id)

    # Если партия не в статусе Завершено или Отменено
    return false unless batch.step_completed?

    # Если план не для полуфабрикатов
    return false unless batch.production_unit.plan.semi?

    # Если уже есть приход для данной партии
    return false if Waybill.filter_by_kind(:arrival).exists?(batch_id: batch.id)

    batch.transaction do
      leftovers = batch.cooked_semi_products.map do |cooked|
        {
          subject_type: "SemiProduct",
          subject_id: cooked.semi_product_id,
          count: cooked.tonnage
        }
      end

      # Приход полуфабрикатов
      waybill = Waybill.create!(new_storage_id: batch.storage_id, batch_id: batch.id, kind: :arrival)
      waybill.leftovers.build(leftovers)
      waybill.save!

      # Удачно если все вставки прошли
      return true
    end

    # Если транзакция вернулась
    false
  end
end
