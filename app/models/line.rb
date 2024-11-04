class Line < ApplicationRecord
  include Deactivatable, Codable, Markable, Locatable, Repeatable

  has_many :zones, through: :locations, source: :positionable, source_type: "Zone"
  has_many :stacks, through: :elements, source: :storable, source_type: "Stack"

  def counter_base
    self.stacks.count
  end

  private
    def generate_code
      parts = [ "L", SecureRandom.hex(8) ]
      parts.join("-").upcase
    end
end
