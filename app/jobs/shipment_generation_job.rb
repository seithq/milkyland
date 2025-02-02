class ShipmentGenerationJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid) do |exception|
    Rails.logger.error("ShipmentGenerationJob: #{exception.message}")
  end

  def perform(plan_id)
    plan = Plan.find(plan_id)

    # Создаем только для законченных планов
    return false unless plan.produced?

    # Если нет распределения QR
    return false unless plan.distributed_products.any?

    # Если уже есть план на отгрузку
    return false if plan.shipments.any?

    plan.transaction do
      regions = plan.distributed_products.pluck(:region_id).uniq
      regions.each do |region_id|
        shipment = plan.shipments.create! region_id: region_id, shipping_date: plan.production_date
        route_sheet = shipment.route_sheets.create! generated: true
        plan.distributed_products.filter_by_region(region_id).each do |dp|
          next if dp.count.zero?
          route_sheet.tracking_products.create! product_id: dp.packaged_product.product_id, count: dp.count, unrestricted_count: 0
        end
      end
    end

    plan.shipments.count > 0
  end
end
