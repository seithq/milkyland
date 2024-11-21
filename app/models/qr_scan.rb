class QrScan < ApplicationRecord
  belongs_to :waybill
  belongs_to :sourceable, polymorphic: true
  belongs_to :box

  validates_uniqueness_of :box_id, scope: :waybill_id
  validates_presence_of :capacity_before, :capacity_after
  validates_numericality_of :capacity_before, :capacity_after, greater_than: 0

  scope :scanned, -> { where.not(scanned_at: nil) }
  scope :not_scanned, -> { where(scanned_at: nil) }
  scope :filter_by_scanning_code, ->(code) { joins(:box).where("qr_scans.code = ? OR boxes.code = ?", code, code) }

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
