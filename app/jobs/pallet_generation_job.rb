class PalletGenerationJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    Rails.logger.error("PalletGenerationJob: #{exception.message}")
  end

  def perform(request_id)
    pallet_request = PalletRequest.find(request_id)

    pallet_request.count.times do
      pallet = Pallet.create!(pallet_request_id: pallet_request.id)

      png = RQRCode::QRCode.new(pallet.code).as_png(
        bit_depth: 1,
        border_modules: 4,
        color_mode: ChunkyPNG::COLOR_GRAYSCALE,
        color: "black",
        file: nil,
        fill: "white",
        module_px_size: 6,
        resize_exactly_to: false,
        resize_gte_to: false,
        size: 240
      )
      pallet.qr_image.attach(io: StringIO.new(png.to_s), filename: "#{pallet.code}.png")
    end
  end
end
