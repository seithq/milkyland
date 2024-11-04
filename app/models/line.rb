class Line < ApplicationRecord
  include Deactivatable, Codable, Markable, Locatable, Repeatable

  has_many :zones, through: :locations, source: :positionable, source_type: "Zone"
  has_many :stacks, through: :elements, source: :storable, source_type: "Stack"

  has_many :tiers, through: :stacks
  has_many :pallets_in_tiers, through: :tiers, source: :pallets
  has_many :boxes_in_tiers, through: :tiers, source: :boxes
  has_many :boxes_in_tiers_in_pallets, through: :tiers, source: :boxes_in_pallets

  def counter_base
    self.stacks.count
  end

  private
    def generate_code
      parts = [ "L", SecureRandom.hex(8) ]
      parts.join("-").upcase
    end

    def pallet_scopes
      [ pallets_in_tiers ]
    end

    def box_scopes
      [ boxes_in_tiers, boxes_in_tiers_in_pallets ]
    end
end
