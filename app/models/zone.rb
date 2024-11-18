class Zone < ApplicationRecord
  include Deactivatable, Codable, Markable, Locatable, QrGeneratable

  enum :kind, %w[ arrival hold ship ].index_by(&:itself), default: :hold

  has_many :storages, through: :locations, source: :positionable, source_type: "Storage"

  # Прямые адреса
  has_many :lines, through: :elements, source: :storable, source_type: "Line"
  has_many :pallets, through: :elements, source: :storable, source_type: "Pallet"
  has_many :boxes, through: :elements, source: :storable, source_type: "Box"
  has_many :boxes_in_pallets, through: :pallets, source: :boxes

  # Сквозные адреса
  has_many :stacks, through: :lines
  has_many :tiers, through: :stacks
  has_many :pallets_in_tiers, through: :tiers, source: :pallets
  has_many :boxes_in_tiers, through: :tiers, source: :boxes
  has_many :boxes_in_tiers_in_pallets, through: :tiers, source: :boxes_in_pallets

  has_many :child_qr_scans, as: :sourceable, class_name: "QrScan", dependent: :destroy

  scope :filter_by_kind, ->(kind) { where(kind: kind) }

  def counter_base
    self.lines.count
  end

  private
    def generate_code
      parts = [ "Z", SecureRandom.hex(8) ]
      parts.join("-").upcase
    end

    def pallet_scopes
      [ pallets, pallets_in_tiers ]
    end

    def box_scopes
      [ boxes, boxes_in_pallets, boxes_in_tiers, boxes_in_tiers_in_pallets ]
    end

    def hierarchy_classes
      %w[ Storage ]
    end
end
