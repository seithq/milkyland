class Tier < ApplicationRecord
  include Deactivatable, Codable, Markable, Locatable, Repeatable

  has_many :stacks, through: :locations, source: :positionable, source_type: "Stack"
  has_many :pallets, through: :elements, source: :storable, source_type: "Pallet"
  has_many :boxes, through: :elements, source: :storable, source_type: "Box"

  private
    def generate_code
      parts = [ "T", SecureRandom.hex(8) ]
      parts.join("-").upcase
    end
end
