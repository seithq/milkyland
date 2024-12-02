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
        qr_scan = QrScan.new groupable: self,
                             code: sourceable.code,
                             sourceable: sourceable,
                             box: box,
                             capacity_before: box.capacity,
                             capacity_after: box.capacity,
                             scanned_at: scanned_at

        if calculate_fifo_boxes(box.product_id).exists?(id: box.id)
          qr_scan.save
        else
          qr_scan.errors.add(:box_id, :inclusion)
        end

        qr_scan
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

  def calculate_fifo_boxes(product_id, strict: false)
    storage = zone.current_position
    return [] unless storage

    tracking_products = route_sheet.tracking_products.filter_by_product(product_id)
    return [] if tracking_products.count.zero?

    tracking_product = tracking_products.first
    box_ids = storage.all_boxes.pluck(:id)

    params = [ product_id, tracking_product.count, tracking_product.unrestricted_count.presence || 0, box_ids ]
    if route_sheet.shipment.has_custom_fifo?
      params << route_sheet.shipment.client.fifo_in_days.days.ago
    end

    method = strict ? "calculated_strict_fifo_for" : "calculated_fifo_for"

    Box.send(method, *params)
  end

  private
    def qr_scans_integrity
      return unless approved?

      if has_delta?
        errors.add(:qr_scans, :accepted)
      else
        errors.add(:qr_scans, :inclusion) if has_missing_fifo?
      end
    end

    def has_delta?
      products_progress.each do |info|
        return true if info[:scanned] != info[:planned]
      end

      false
    end

    def has_missing_fifo?
      products_and_counts.map do |product_id, _|
        required_boxes = calculate_fifo_boxes product_id, strict: true
        scanned = qr_scans.filter_by_box(required_boxes.pluck(:id))

        return true if scanned.count != required_boxes.count
      end

      false
    end
end
