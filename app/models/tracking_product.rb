class TrackingProduct < ApplicationRecord
  belongs_to :route_sheet
  belongs_to :product

  before_validation :set_unrestricted_count

  validates :count, presence: true, numericality: { greater_than: 0 }
  validates_numericality_of :unrestricted_count, less_than_or_equal_to: :count, allow_nil: true
  validates_uniqueness_of :product_id, scope: :route_sheet_id

  scope :filter_by_product, ->(product_id) { where(product_id: product_id) }

  private
    def set_unrestricted_count
      self.unrestricted_count = 0 if self.unrestricted_count.nil?
    end
end
