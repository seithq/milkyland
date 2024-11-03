class Zone < ApplicationRecord
  include Deactivatable, Codable, Markable, Locatable

  enum :kind, %w[ hold ship ].index_by(&:itself), default: :hold

  has_many :storages, through: :locations, source: :positionable, source_type: "Storage"

  scope :ordered, -> { order(display_index: :asc) }

  private
    def generate_code
      parts = [ "Z", SecureRandom.hex(8) ]
      parts.join("-").upcase
    end
end
