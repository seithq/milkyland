class ProcessReturnJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    Rails.logger.error("ProcessReturnJob: #{exception.message}")
  end

  def perform(return_id)
    record = Return.find(return_id)

    # Пользователь должен подтвердить статус
    return false unless record.approved?

    # Запись должна иметь позиции на возврат
    products_scope = record.returned_products
    return false if products_scope.count.zero?

    record.transaction do
      waybill = Waybill.create! kind: :return_back,
                                new_storage_id: record.storage_id,
                                sender_id: record.user_id,
                                status: :draft

      products_scope.each do |returned|
        box = Box.create! region_id: record.order.sales_point.region_id,
                          product_id: returned.product_id,
                          capacity: returned.count,
                          production_date: record.order.preferred_date,
                          expiration_date: record.order.preferred_date + returned.product.expiration_in_days.days,
                          returned_product_id: returned.id

        QrGenerationJob.perform_now(box)

        waybill.leftovers.create! subject: returned.product, count: returned.count
        waybill.add_qr box.code, scanned_at: Time.current
      end

      waybill.update! status: :approved

      zone = waybill.new_storage.zones.filter_by_kind(:arrival).first
      waybill.qr_scans.each do |qr_scan|
        qr_scan.sourceable.locate_to zone
      end

      true
    rescue ActiveRecord::RecordInvalid => exception
      Rails.logger.error("ProcessReturnJob: #{exception.message}")
      false
    end
  end
end
