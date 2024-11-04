class Zone < ApplicationRecord
  include Deactivatable, Codable, Markable, Locatable

  enum :kind, %w[ hold ship ].index_by(&:itself), default: :hold

  has_many :storages, through: :locations, source: :positionable, source_type: "Storage"
  has_many :lines, through: :elements, source: :storable, source_type: "Line"

  def counter_base
    self.lines.count
  end

  private
    def generate_code
      parts = [ "Z", SecureRandom.hex(8) ]
      parts.join("-").upcase
    end
end
