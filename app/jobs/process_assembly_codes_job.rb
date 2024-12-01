class ProcessAssemblyCodesJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    Rails.logger.error("ProcessAssemblyCodesJob: #{exception.message}")
  end

  def perform(assembly_id)
    assembly = Assembly.find(assembly_id)

    # Skip if not approved
    return false unless assembly.approved?

    # Skip if there is no scan inside
    return false if assembly.qr_scans.count.zero?

    assembly.transaction do
      assembly.route_sheet.update! status: :collected
      assembly.qr_scans.each do |qr_scan|
        qr_scan.sourceable.locate_to assembly.zone
      end
    end

    true
  rescue ActiveRecord::RecordInvalid => exception
    Rails.logger.error("ProcessAssemblyCodesJob: #{exception.message}")
    false
  end
end
