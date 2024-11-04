class Box < ApplicationRecord
  include Codable, Scannable, Locatable

  belongs_to :region
  belongs_to :product
  belongs_to :box_request, optional: true

  has_one_attached :qr_image, dependent: :purge_later

  has_many :pallets, through: :locations, source: :positionable, source_type: "Pallet"

  validates_presence_of :production_date, :expiration_date
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  broadcasts_refreshes_to ->(box) { box.box_request.present? ? box.box_request.generation : ""  }

  scope :filter_by_region, ->(region_id) { where(region_id: region_id) }

  private
    def generate_code
      parts = [
        "B",
        region.code,
        product.article,
        capacity,
        production_date.strftime("%Y%m%d"),
        expiration_date.strftime("%Y%m%d"),
        SecureRandom.hex(8)
      ]
      parts.join("-").upcase
    end
end
