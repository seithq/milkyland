class QrScan < ApplicationRecord
  belongs_to :groupable, polymorphic: true
  belongs_to :sourceable, polymorphic: true
  belongs_to :box

  validates_uniqueness_of :box_id, scope: %i[ groupable_id groupable_type ]
  validates_presence_of :capacity_before, :capacity_after
  validates_numericality_of :capacity_before, :capacity_after, greater_than: 0

  scope :scanned, -> { where.not(scanned_at: nil) }
  scope :not_scanned, -> { where(scanned_at: nil) }
  scope :filter_by_scanning_code, ->(code) { joins(:box).where("qr_scans.code = ? OR boxes.code = ?", code, code) }
  scope :filter_by_product, ->(product_id) { joins(box: :product).where(products: { id: product_id }) }
  scope :filter_by_box, ->(box_id) { where(box_id: box_id) }

  def is_box?
    self.sourceable_type == Box.model_name.name
  end

  def capacity_delta
    self.capacity_before - self.capacity_after
  end

  def scanned?
    scanned_at?
  end

  def full?
    capacity_after == capacity_before
  end
end
