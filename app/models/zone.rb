class Zone < ApplicationRecord
  include Deactivatable, Codable, Markable, Locatable

  enum :kind, %w[ hold ship ].index_by(&:itself), default: :hold

  has_many :storages, through: :locations, source: :positionable, source_type: "Storage"

  # Прямые адреса
  has_many :lines, through: :elements, source: :storable, source_type: "Line"
  has_many :pallets, through: :elements, source: :storable, source_type: "Pallet"
  has_many :boxes, through: :elements, source: :storable, source_type: "Box"

  # Сквозные адреса
  has_many :stacks, through: :lines
  has_many :tiers, through: :stacks

  def counter_base
    self.lines.count
  end

  private
    def generate_code
      parts = [ "Z", SecureRandom.hex(8) ]
      parts.join("-").upcase
    end
end
