class BoxGenerationJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    Rails.logger.error("BoxGenerationJob: #{exception.message}")
  end

  def perform(generation_id)
    generation = Generation.find(generation_id)
    return false unless generation.in_planning?

    generation.start!

    generation.transaction do
      plan_count = generation.distributed_product.count

      generation.box_requests.ordered.each do |box_request|
        pieces = box_request.box_packaging.count

        box_request.count.times do
          capacity = plan_count >= pieces ? pieces : plan_count
          product  = generation.distributed_product.packaged_product.product
          prod_dt  = generation.distributed_product.production_date

          box = Box.create!(
            region_id: generation.distributed_product.region.id,
            product_id: product.id,
            capacity: capacity,
            production_date: prod_dt,
            expiration_date: prod_dt + product.expiration_in_days.days,
            box_request_id: box_request.id
          )

          QrGenerationJob.perform_now(box)
          plan_count -= capacity
        end
      end

      raise ActiveRecord::Rollback unless plan_count == 0
    end

    generation.finish!
  end
end
