require "mini_magick"

class QrGenerationJob < ApplicationJob
  queue_as :default

  def perform(codable)
    code = RQRCode::QRCode.new(codable.code).as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      file: nil,
      fill: "white",
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 500
    )

    qrcode_image = MiniMagick::Image.read(StringIO.new(code.to_s))

    qrcode_image.combine_options do |options|
      options.font "#{ Rails.root }/public/fonts/FiraCode.ttf"
      options.gravity "South"
      options.pointsize 40
      options.draw "text 0,10 '#{ codable.code }'"
    end

    result = qrcode_image.combine_options do |options|
      options.font "#{ Rails.root }/public/fonts/FiraCode.ttf"
      options.gravity "North"

      if should_print_parent? codable
        options.pointsize 24
        options.draw "text 0,5 '#{ generate_caption codable }'"
        options.draw "text 0,30 '#{ generate_caption codable.current_position }'"
      else
        options.pointsize 40
        options.draw "text 0,10 '#{ generate_caption codable }'"
      end
    end

    codable.qr_image.attach(io: StringIO.new(result.to_blob), filename: "#{codable.code}.png")
  end

  private
    def generate_caption(codable)
      key = codable.caption_key

      if codable.respond_to? :display_index
        I18n.t("pages.#{ key }", index: codable.display_index)
      else
        I18n.t("pages.#{ key }")
      end
    end

    def should_print_parent?(codable)
      return false if %w[ Box Pallet ].include? codable.model_name.human
      codable.respond_to?(:current_position) && codable.current_position
    end
end
