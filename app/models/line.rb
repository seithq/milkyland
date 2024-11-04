class Line < ApplicationRecord
  include Deactivatable, Codable, Markable, Locatable

  has_many :zones, through: :locations, source: :positionable, source_type: "Zone"

  attribute :repeat, :integer, default: 1

  def self.repeat(n, zone)
    self.transaction do
      n.to_i.times do
        line = Line.create!(active: true, index_position: zone.lines.count)
        line.locate_to zone
      end

      true
    rescue ActiveRecord::Rollback
      return false
    end
  end

  private
    def generate_code
      parts = [ "L", SecureRandom.hex(8) ]
      parts.join("-").upcase
    end
end
