class Box < ApplicationRecord
  include Codable, Scannable, Locatable, AddressSearchable, Fifo

  belongs_to :region
  belongs_to :product
  belongs_to :box_request, optional: true

  has_many :pallets, through: :locations, source: :positionable, source_type: "Pallet"
  has_many :zones, through: :locations, source: :positionable, source_type: "Zone"
  has_many :tiers, through: :locations, source: :positionable, source_type: "Tier"

  has_many :qr_scans, dependent: :destroy
  has_many :child_qr_scans, as: :sourceable, class_name: "QrScan", dependent: :destroy

  validates_presence_of :production_date, :expiration_date
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  broadcasts_refreshes_to ->(box) { box.box_request.present? ? box.box_request.generation : "" }

  scope :filter_by_region, ->(region_id) { where(region_id: region_id) }
  scope :filter_by_product, ->(product_id) { where(product_id: product_id) }

  scope :filter_by_pallet_address, ->(address) { joins(:pallets).merge(Pallet.filter_by_code(address)) }
  scope :filter_by_zone_address, ->(address) { joins(:zones).merge(Zone.filter_by_code(address)) }
  scope :filter_by_tier_address, ->(address) { joins(:tiers).merge(Tier.filter_by_code(address)) }

  scope :filter_by_production_date, ->(production_date) { where(production_date: production_date) }

  scope :active, -> { where(taken_out_at: nil) }

  def self.prefix_to_scope
    {
      "Z": "filter_by_zone_address",
      "T": "filter_by_tier_address",
      "P": "filter_by_pallet_address"
    }
  end

  private
    def generate_code
      parts = [ "B", SecureRandom.hex(8) ]
      parts.join("-").upcase
    end

    def hierarchy_classes
      %w[ Zone Tier Pallet ]
    end

    def box_scopes
      [ Box.where(id: self.id) ]
    end
end
