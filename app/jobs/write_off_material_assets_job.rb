class WriteOffMaterialAssetsJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid) do |exception|
    Rails.logger.error("WriteOffMaterialAssetsJob: #{exception.message}")
  end

  def perform(batch_id)
    batch = Batch.find(batch_id)

    # Если партия не в статусе Завершено или Отменено
    return false unless batch.step_completed?

    # Если уже есть списание для данной партии
    return false if Waybill.filter_by_kind(:production_write_off).exists?(batch_id: batch.id)

    batch.transaction do
      tonnage = batch.produced_tonnage

      # Список полуабрикатов
      leftovers = batch.group.semi_ingredients.active.map do |semi_ingredient|
        {
          subject_type: "SemiProduct",
          subject_id: semi_ingredient.semi_product_id,
          count: semi_ingredient.ratio * tonnage
        }
      end

      # Список сырья
      leftovers << batch.group.ingredients.active.map do |ingredient|
        {
          subject_type: "MaterialAsset",
          subject_id: ingredient.material_asset_id,
          count: ingredient.ratio * tonnage
        }
      end

      # Добавляем тару или упаковку
      leftovers << batch.machineries.map do |machinery|
        {
          subject_type: "MaterialAsset",
          subject_id: machinery.material_asset_id,
          count: machinery.count
        }
      end

      # Добавляем коробки
      leftovers << batch.box_requests.positive.map do |box_request|
        {
          subject_type: "MaterialAsset",
          subject_id: box_request.box_packaging.material_asset_id,
          count: box_request.count
        }
      end

      # Списание сырья
      waybill = Waybill.create!(storage_id: batch.storage_id, batch_id: batch.id, kind: :production_write_off, status: :approved)
      waybill.leftovers.build(leftovers)
      waybill.save!

      # Удачно если все вставки прошли
      return true
    end

    # Если транзакция вернулась
    false
  end
end
