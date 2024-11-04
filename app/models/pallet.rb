class Pallet < ApplicationRecord
  include Codable, Scannable, Locatable

  belongs_to :pallet_request, optional: true

  has_one_attached :qr_image, dependent: :purge_later

  has_many :boxes, through: :elements, source: :storable, source_type: "Box"

  broadcasts_refreshes_to ->(pallet) { pallet.pallet_request.present? ? pallet.pallet_request.generation : "" }

  private
    def generate_code
      parts = [ "P", SecureRandom.hex(8) ]
      parts.join("-").upcase
    end
end
