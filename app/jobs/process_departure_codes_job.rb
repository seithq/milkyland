class ProcessDepartureCodesJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    Rails.logger.error("ProcessDepartureCodesJob: #{exception.message}")
  end

  def perform(waybill_id)
    waybill = Waybill.find(waybill_id)

    # Skip if wrong kind
    return false unless waybill.departure?

    # Skip if not approved
    return false unless waybill.approved?

    # Skip if there is no scan inside
    return false if waybill.qr_scans.count.zero?

    waybill.transaction do
      product_list = build_product_list waybill.qr_scans
      product_list.each do | id, count |
        waybill.leftovers.create! subject_type: "Product", subject_id: id, count: count
      end

      waybill.qr_scans.each do |qr_scan|
        box = qr_scan.box
        box.update! capacity: qr_scan.capacity_delta
        if qr_scan.capacity_delta == 0
          box.update! taken_out_at: Time.current
          box.clear_locations!
        end
      end

      if waybill.route_sheet.present?
        waybill.route_sheet.update! status: :completed
        waybill.route_sheet.orders.update_all status: :completed
      end

      if waybill.order.present?
        waybill.order.update! status: :completed
      end

      true
    rescue ActiveRecord::RecordInvalid => exception
      Rails.logger.error("ProcessDepartureCodesJob: #{exception.message}")
      false
    end
  end

  private
    def build_product_list(qr_scans)
      list = HashWithIndifferentAccess.new
      qr_scans.each do |qr_scan|
        product_id = qr_scan.box.product_id
        previous_capacity = list.has_key?(product_id) ? list[product_id] : 0
        list[product_id] = previous_capacity + qr_scan.capacity_after
      end
      list
    end
end
