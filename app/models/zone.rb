class Zone < ApplicationRecord
  include Deactivatable, Codable, Markable, Locatable

  enum :kind, %w[ hold ship ].index_by(&:itself), default: :hold

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

  def counter_base
    self.lines.count
  end

  def all_pallets
    ids = [ pallets, pallets_in_tiers ].map { |scope| scope.pluck(:id) }.reduce(&:+)
    Pallet.where(id: ids)
  end

  def all_boxes
    ids = [ boxes, boxes_in_pallets, boxes_in_tiers, boxes_in_tiers_in_pallets ].map { |scope| scope.pluck(:id) }.reduce(&:+)
    Box.where(id: ids)
  end

  def capacity_by(product_id)
    all_boxes.filter_by_product(product_id).sum(:capacity)
  end

  private
    def generate_code
      parts = [ "Z", SecureRandom.hex(8) ]
      parts.join("-").upcase
    end
end
