class Pallet < ApplicationRecord
  include Codable, Scannable, Locatable, AddressSearchable

  belongs_to :pallet_request, optional: true

  has_many :tiers, through: :locations, source: :positionable, source_type: "Tier"
  has_many :zones, through: :locations, source: :positionable, source_type: "Zone"
  has_many :boxes, through: :elements, source: :storable, source_type: "Box"

  has_many :child_qr_scans, as: :sourceable, class_name: "QrScan", dependent: :destroy

  scope :filter_by_zone_address, ->(address) { joins(:zones).merge(Zone.filter_by_code(address)) }
  scope :filter_by_tier_address, ->(address) { joins(:tiers).merge(Tier.filter_by_code(address)) }

  broadcasts_refreshes_to ->(pallet) { pallet.pallet_request.present? ? pallet.pallet_request.generation : "" }

  def self.prefix_to_scope
    {
      "Z": "filter_by_zone_address",
      "T": "filter_by_tier_address"
    }
  end

  def capacity
    boxes.sum(:capacity)
  end

  private
    def generate_code
      parts = [ "P", SecureRandom.hex(8) ]
      parts.join("-").upcase
    end

    def box_scopes
      [ boxes ]
    end

    def hierarchy_classes
      %w[ Zone Tier ]
    end
end
