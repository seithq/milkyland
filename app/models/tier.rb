class Tier < ApplicationRecord
  include Deactivatable, Codable, Markable, Locatable, Repeatable, QrGeneratable

  has_many :stacks, through: :locations, source: :positionable, source_type: "Stack"
  has_many :pallets, through: :elements, source: :storable, source_type: "Pallet"
  has_many :boxes, through: :elements, source: :storable, source_type: "Box"
  has_many :boxes_in_pallets, through: :pallets, source: :boxes

  private
    def generate_code
      parts = [ "T", SecureRandom.hex(8) ]
      parts.join("-").upcase
    end

    def pallet_scopes
      [ pallets ]
    end

    def box_scopes
      [ boxes, boxes_in_pallets ]
    end

    def hierarchy_classes
      %w[ Stack ]
    end
end
