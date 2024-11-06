class Stack < ApplicationRecord
  include Deactivatable, Codable, Markable, Locatable, Repeatable, QrGeneratable

  has_many :lines, through: :locations, source: :positionable, source_type: "Line"
  has_many :tiers, through: :elements, source: :storable, source_type: "Tier"

  has_many :pallets_in_tiers, through: :tiers, source: :pallets
  has_many :boxes_in_tiers, through: :tiers, source: :boxes
  has_many :boxes_in_tiers_in_pallets, through: :tiers, source: :boxes_in_pallets

  def counter_base
    self.tiers.count
  end

  private
    def generate_code
      parts = [ "S", SecureRandom.hex(8) ]
      parts.join("-").upcase
    end

    def pallet_scopes
      [ pallets_in_tiers ]
    end

    def box_scopes
      [ boxes_in_tiers, boxes_in_tiers_in_pallets ]
    end
end
