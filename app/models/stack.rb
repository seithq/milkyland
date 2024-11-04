class Stack < ApplicationRecord
  include Deactivatable, Codable, Markable, Locatable, Repeatable

  has_many :lines, through: :locations, source: :positionable, source_type: "Line"

  def counter_base
    0
  end

  private
    def generate_code
      parts = [ "S", SecureRandom.hex(8) ]
      parts.join("-").upcase
    end
end
