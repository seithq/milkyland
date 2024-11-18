class ProcessArrivalCodesJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    Rails.logger.error("ProcessArrivalCodesJob: #{exception.message}")
  end

  def perform(waybill_id)
    waybill = Waybill.find(waybill_id)

    # Skip if not approved
    return false unless waybill.approved?

    # Skip if there is no scan inside
    return false if waybill.qr_scans.count.zero?

    waybill.transaction do
      product_list = build_product_list waybill.qr_scans
      product_list.each do | id, count |
        waybill.leftovers.create! subject_type: "Product", subject_id: id, count: count
      end

      zone = waybill.new_storage.zones.filter_by_kind(:arrival).first
      waybill.qr_scans.each do |qr_scan|
        qr_scan.sourceable.locate_to zone
      end

      true
    rescue ActiveRecord::RecordInvalid => exception
      Rails.logger.error("ProcessArrivalCodesJob: #{exception.message}")
      false
    end
  end

  private
    def build_product_list(qr_scans)
      list = HashWithIndifferentAccess.new
      qr_scans.each do |qr_scan|
        product_id = qr_scan.box.product_id
        previous_capacity = list.has_key?(product_id) ? list[product_id] : 0
        list[product_id] = previous_capacity + qr_scan.box.capacity
      end
      list
    end
end
