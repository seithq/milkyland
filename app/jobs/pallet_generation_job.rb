class PalletGenerationJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    Rails.logger.error("PalletGenerationJob: #{exception.message}")
  end

  def perform(request_id)
    pallet_request = PalletRequest.find(request_id)

    pallet_request.count.times do
      pallet = Pallet.create!(pallet_request_id: pallet_request.id)
      QrGenerationJob.perform_later(pallet)
    end
  end
end
