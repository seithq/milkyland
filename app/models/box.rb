class Box < ApplicationRecord
  include Codable, Scannable, Locatable, AddressSearchable

  belongs_to :region
  belongs_to :product
  belongs_to :box_request, optional: true

  has_one_attached :qr_image, dependent: :purge_later

  has_many :pallets, through: :locations, source: :positionable, source_type: "Pallet"
  has_many :zones, through: :locations, source: :positionable, source_type: "Zone"
  has_many :tiers, through: :locations, source: :positionable, source_type: "Tier"

  validates_presence_of :production_date, :expiration_date
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  broadcasts_refreshes_to ->(box) { box.box_request.present? ? box.box_request.generation : "" }

  scope :filter_by_region, ->(region_id) { where(region_id: region_id) }
  scope :filter_by_product, ->(product_id) { where(product_id: product_id) }

  scope :filter_by_pallet_address, ->(address) { joins(:pallets).merge(Pallet.filter_by_code(address)) }
  scope :filter_by_zone_address, ->(address) { joins(:zones).merge(Zone.filter_by_code(address)) }
  scope :filter_by_tier_address, ->(address) { joins(:tiers).merge(Tier.filter_by_code(address)) }

  def self.prefix_to_scope
    {
      "Z": "filter_by_zone_address",
      "T": "filter_by_tier_address",
      "P": "filter_by_pallet_address"
    }
  end

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
