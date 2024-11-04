class Stack < ApplicationRecord
  include Deactivatable, Codable, Markable, Locatable, Repeatable

  has_many :lines, through: :locations, source: :positionable, source_type: "Line"
  has_many :tiers, through: :elements, source: :storable, source_type: "Tier"

  def counter_base
    self.tiers.count
  end

  private
    def generate_code
      parts = [ "S", SecureRandom.hex(8) ]
      parts.join("-").upcase
    end
end
