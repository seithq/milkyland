class Assembly < ApplicationRecord
  belongs_to :route_sheet
  belongs_to :zone
  belongs_to :user

  has_many :qr_scans, as: :groupable, dependent: :destroy
  validate :qr_scans_integrity

  enum :status, %w[ draft approved ].index_by(&:itself), default: :draft

  scope :filter_by_status, ->(status) { where(status: status) }

  def add_qr(code, scanned_at: nil, allowed_prefixes: %w[ P B ])
    sourceable = Scan.find_by code, allowed_prefixes: allowed_prefixes
    return unless sourceable

    transaction do
      sourceable.all_boxes.map do |box|
        QrScan.create groupable_id: self.id,
                      groupable_type: "Assembly",
                      code: sourceable.code,
                      sourceable: sourceable,
                      box: box,
                      capacity_before: box.capacity,
                      capacity_after: box.capacity,
                      scanned_at: scanned_at
      end
    end
  end

  def products_progress
    products_and_counts.map do |product_id, total_count|
      product = Product.find(product_id)
      scanned = qr_scans.filter_by_product(product_id).sum(:capacity_after)
      HashWithIndifferentAccess.new(
        product: product,
        scanned: scanned,
        planned: total_count,
        progress: (scanned.to_d / total_count.to_d) * 100.0
      )
    end
  end

  def products_and_counts
    route_sheet.tracking_products.group(:product_id).sum(:count)
  end

  private
    def qr_scans_integrity
      return unless approved?

      errors.add(:qr_scans, :accepted) if has_delta?
    end

    def has_delta?
      products_progress.each do |info|
        return true if info[:scanned] != info[:planned]
      end

      false
    end
end
