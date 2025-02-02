class Waybill < ApplicationRecord
  include Deactivatable

  belongs_to :storage, optional: true
  belongs_to :new_storage, class_name: "Storage", foreign_key: "new_storage_id", optional: true

  belongs_to :sender, class_name: "User", foreign_key: "sender_id", optional: true
  belongs_to :receiver, class_name: "User", foreign_key: "receiver_id", optional: true

  belongs_to :batch, optional: true
  belongs_to :route_sheet, optional: true
  belongs_to :order, optional: true

  has_many :leftovers, dependent: :destroy
  has_many :qr_scans, as: :groupable, dependent: :destroy

  enum :kind, %w[ arrival departure transfer write_off production_write_off return_back ].index_by(&:itself)
  enum :status, %w[ draft pending approved ].index_by(&:itself), default: :draft

  validates_presence_of :storage_id, unless: ->() { arrival? || return_back? }
  validates_presence_of :new_storage_id, if: ->() { arrival? || transfer? || return_back? }
  validates_presence_of :batch_id, if: :production_write_off?
  validates_presence_of :route_sheet_id, if: :collectable?
  validates_presence_of :order_id, if: ->(waybill) { !waybill.collectable? && waybill.departure? }

  validate :storage_integrity
  validate :qr_scans_integrity
  validate :route_sheet_integrity
  validate :order_integrity

  scope :filter_by_kind, ->(kind) { where(kind: kind) }
  scope :automatic, ->() { filter_by_kind(:production_write_off) }

  scope :for_material_assets, ->() { left_joins(:storage).left_joins(:new_storage).where(storages: { kind: %i[ for_material_assets for_masters_material_assets ] }).or(where(new_storages_waybills: { kind: %i[ for_material_assets for_masters_material_assets ] })) }
  scope :for_goods, ->() { left_joins(:storage).left_joins(:new_storage).where(storages: { kind: %i[ for_masters for_goods ] }).or(where(new_storages_waybills: { kind: %i[ for_masters for_goods ] })) }

  scope :filter_by_both_storage, ->(storage_id) { where(storage_id: storage_id).or(where(new_storage_id: storage_id)) }

  scope :filter_by_storage, ->(storage_id) { where(storage_id: storage_id) }
  scope :filter_by_new_storage, ->(storage_id) { where(new_storage_id: storage_id) }
  scope :filter_by_date, ->(date) { where(created_at: date.beginning_of_day..date.end_of_day) }

  scope :drafts, -> { where(status: :draft) }
  scope :pendings, -> { where(status: :pending) }

  scope :returnable, -> { where(kind: :departure, status: :approved).where.not(order_id: nil) }
  scope :without_return_back, -> { where.not kind: :return_back }

  scope :report_for_arrivals, ->() do
    joins(:leftovers, qr_scans: { box: { product: :group } })
      .where(kind: :arrival, status: :approved)
      .select(
        "groups.id AS group_id",
        "groups.name AS group_name",
        "products.id AS product_id",
        "products.name AS product_name",
        "SUM(qr_scans.capacity_after) AS total_count",
        "boxes.production_date"
      )
      .group("groups.id, groups.name, products.id, products.name, boxes.production_date")
      .order("groups.name, products.name, boxes.production_date")
  end

  scope :report_for_transfers, ->() do
    joins(:leftovers, qr_scans: { box: { product: :group } })
      .where(kind: :transfer, status: :approved)
      .select(
        "groups.id AS group_id",
        "groups.name AS group_name",
        "products.id AS product_id",
        "products.name AS product_name",
        "SUM(qr_scans.capacity_after) AS total_count",
        "boxes.production_date"
      )
      .group("groups.id, groups.name, products.id, products.name, boxes.production_date")
      .order("groups.name, products.name, boxes.production_date")
  end

  scope :report_for_write_offs, ->() do
    joins(:leftovers)
      .joins("JOIN material_assets ON leftovers.subject_id = material_assets.id AND leftovers.subject_type = 'MaterialAsset'")
      .joins("JOIN categories ON material_assets.category_id = categories.id")
      .joins("JOIN measurements ON material_assets.measurement_id = measurements.id")
      .select(
        "categories.id AS category_id",
        "categories.name AS category_name",
        "material_assets.id AS material_asset_id",
        "material_assets.name AS material_asset_name",
        "measurements.unit AS measurement_unit",
        "ABS(SUM(leftovers.count)) AS total_count"
      )
      .group("categories.id, categories.name, material_assets.id, material_assets.name, measurements.unit")
      .order("categories.name, material_assets.name")
  end

  def editable?
    self.new_record? && self.active?
  end

  def add_qr(code, scanned_at: nil, allowed_prefixes: %w[ Z P B ])
    sourceable = Scan.find_by code, allowed_prefixes: allowed_prefixes
    return unless sourceable

    transaction do
      sourceable.all_boxes.map do |box|
        QrScan.create groupable: self,
                      code: sourceable.code,
                      sourceable: sourceable,
                      box: box,
                      capacity_before: box.capacity,
                      capacity_after: box.capacity,
                      scanned_at: scanned_at
      end
    end
  end

  def progress
    return 0.0 if qr_scans.count.zero?

    (before_scope.sum(:capacity_after).to_d / qr_scans.sum(:capacity_before).to_d) * 100.0
  end

  def before_scope
    return qr_scans unless pending?
    qr_scans.scanned
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
    case true
    when route_sheet.present?
      route_sheet.tracking_products.group(:product_id).sum(:count)
    when order.present?
      order.positions.group(:product_id).sum(:count)
    else
      Box.where(id: qr_scans.pluck(:box_id)).group(:product_id).sum(:capacity)
    end
  end

  def calculate_fifo_boxes(product_id, strict: false)
    return [] unless order

    positions = order.positions.filter_by_product(product_id)
    return [] if positions.count.zero?

    position = positions.first
    box_ids = storage.all_boxes.pluck(:id)

    params = [ product_id, position.count, 0, box_ids ]
    method = strict ? "calculated_strict_fifo_for" : "calculated_fifo_for"

    Box.send(method, *params)
  end

  private
    def storage_integrity
      errors.add(:new_storage_id, :inclusion) if storage_id == new_storage_id
    end

    def qr_scans_integrity
      return unless approved?
      return if manual_approval?

      if has_not_scanned? || has_delta?
        errors.add(:qr_scans, :accepted)
      else
        errors.add(:qr_scans, :inclusion) if order.present? && has_missing_fifo?
      end
    end

    def route_sheet_integrity
      return unless should_validate_collectable?

      errors.add(:qr_scans, :inclusion) if has_route_sheet_imbalance?
    end

    def order_integrity
      return unless should_validate_order?

      errors.add(:qr_scans, :inclusion) if has_order_imbalance?
    end

    def should_validate_collectable?
      collectable? && (transfer? && pending? || departure? && approved?)
    end

    def should_validate_order?
      !new_record? && !collectable? && order.present?
    end

    def has_not_scanned?
      qr_scans.not_scanned.count > 0
    end

    def has_delta?
      !(write_off? || departure?) && capacity_delta > 0
    end

    def capacity_delta
      qr_scans.sum(:capacity_before) - qr_scans.sum(:capacity_after)
    end

    def has_route_sheet_imbalance?
      scope = route_sheet.assemblies.filter_by_status(:approved)
      return true if scope.empty?

      assembly = scope.recent_first.limit(1).first
      assembled = assembly.qr_scans

      scanned = qr_scans.where(box_id: assembled.pluck(:box_id))
      total_count, total_capacity = qr_scans.count, qr_scans.sum(:capacity_after)

      return true unless total_count == scanned.count &&
        total_count == assembled.count

      return true unless total_capacity == scanned.sum(:capacity_after) &&
        total_capacity == assembled.sum(:capacity_after)

      false
    end

    def has_order_imbalance?
      order.positions.each do |position|
        product_capacity = qr_scans
                             .scanned
                             .joins(:box)
                             .where(boxes: { product_id: position.product_id })
                             .sum(:capacity_after)

        return true unless position.count == product_capacity
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
