class Tier < ApplicationRecord
  include Deactivatable, Codable, Markable, Locatable, Repeatable

  has_many :stacks, through: :locations, source: :positionable, source_type: "Stack"
  has_many :pallets, through: :elements, source: :storable, source_type: "Pallet"
  has_many :boxes, through: :elements, source: :storable, source_type: "Box"
  has_many :boxes_in_pallets, through: :pallets, source: :boxes

  def all_boxes
    ids = [ boxes, boxes_in_pallets ].map { |scope| scope.pluck(:id) }.reduce(&:+)
    Box.where(id: ids)
  end

  def capacity_by(product_id)
    all_boxes.filter_by_product(product_id).sum(:capacity)
  end

  private
    def generate_code
      parts = [ "T", SecureRandom.hex(8) ]
      parts.join("-").upcase
    end
end
