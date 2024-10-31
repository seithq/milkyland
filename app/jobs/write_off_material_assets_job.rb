class WriteOffMaterialAssetsJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    Rails.logger.error("WriteOffMaterialAssetsJob: #{exception.message}")
  end

  def perform(batch_id)
    batch = Batch.find(batch_id)

    # Если партия не в статусе Завершено или Отменено
    return false unless batch.step_completed?

    # Если уже есть списание для данной партии
    return false if Waybill.exists?(batch_id: batch.id)

    batch.transaction do
      tonnage = batch.produced_tonnage

      # Список сырья
      leftovers = batch.group.ingredients.map do |ingredient|
        {
          subject_type: "MaterialAsset",
          subject_id: ingredient.material_asset_id,
          count: ingredient.ratio * tonnage
        }
      end

      # Добавляем тару или упаковку
      leftovers << batch.packaged_products.map do |packaged|
        {
          subject_type: "MaterialAsset",
          subject_id: packaged.product.material_asset_id,
          count: packaged.count
        }
      end

      # Добавляем коробки
      leftovers << batch.box_requests.map do |box_request|
        {
          subject_type: "MaterialAsset",
          subject_id: box_request.box_packaging.material_asset_id,
          count: box_request.count
        }
      end

      # Списание сырья
      waybill = Waybill.create!(storage_id: batch.storage_id, batch_id: batch.id, kind: :production_write_off)
      waybill.leftovers.build(leftovers)
      waybill.save!

      # Удачно если все вставки прошли
      return true
    end

    # Если транзакция вернулась
    false
  end
end
