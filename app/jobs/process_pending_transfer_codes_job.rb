class ProcessPendingTransferCodesJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    Rails.logger.error("ProcessPendingTransferCodesJob: #{exception.message}")
  end

  def perform(waybill_id)
    waybill = Waybill.find(waybill_id)

    # Skip if wrong kind
    return false unless waybill.transfer?

    # Skip if not pending
    return false unless waybill.pending?

    # Skip if there is no scan inside
    return false if waybill.qr_scans.count.zero?

    waybill.transaction do
      waybill.qr_scans.each do |qr_scan|
        if waybill.collectable
          qr_scan.box.clear_locations!
        else
          qr_scan.sourceable.clear_locations!
        end
      end

      true
    rescue ActiveRecord::RecordInvalid => exception
      Rails.logger.error("ProcessPendingTransferCodesJob: #{exception.message}")
      false
    end
  end
end
