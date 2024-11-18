class Waybill < ApplicationRecord
  include Deactivatable

  belongs_to :storage, optional: true
  belongs_to :new_storage, class_name: "Storage", foreign_key: "new_storage_id", optional: true

  belongs_to :sender, class_name: "User", foreign_key: "sender_id", optional: true
  belongs_to :receiver, class_name: "User", foreign_key: "receiver_id", optional: true

  belongs_to :batch, optional: true

  has_many :leftovers, dependent: :destroy
  has_many :qr_scans, dependent: :destroy

  enum :kind, %w[ arrival departure transfer write_off production_write_off return_back ].index_by(&:itself)
  enum :status, %w[ draft pending approved ].index_by(&:itself), default: :draft

  validates_presence_of :storage_id, unless: ->() { arrival? }
  validates_presence_of :new_storage_id, if: ->() { arrival? || transfer? || return_back? }
  validates_presence_of :batch_id, if: :production_write_off?

  validate :storage_integrity

  scope :filter_by_kind, ->(kind) { where(kind: kind) }
  scope :automatic, ->() { filter_by_kind(:production_write_off) }

  scope :for_material_assets, ->() { left_joins(:storage).left_joins(:new_storage).where(storages: { kind: :for_material_assets }).or(where(new_storages_waybills: { kind: :for_material_assets })) }
  scope :for_goods, ->() { left_joins(:storage).left_joins(:new_storage).where(storages: { kind: %i[ for_masters for_goods ] }).or(where(new_storages_waybills: { kind: %i[ for_masters for_goods ] })) }

  scope :filter_by_both_storage, ->(storage_id) { where(storage_id: storage_id).or(where(new_storage_id: storage_id)) }

  scope :filter_by_storage, ->(storage_id) { where(storage_id: storage_id) }
  scope :filter_by_new_storage, ->(storage_id) { where(new_storage_id: storage_id) }

  scope :drafts, -> { where(status: :draft) }
  scope :pendings, -> { where(status: :pending) }

  def editable?
    self.new_record? && self.active?
  end

  def add_qr(code, scanned_at: nil, allowed_prefixes: %w[ Z P B ])
    sourceable = Scan.find_by code, allowed_prefixes: allowed_prefixes
    return unless sourceable

    transaction do
      sourceable.all_boxes.map do |box|
        self.qr_scans.create code: sourceable.code,
                             sourceable: sourceable,
                             box: box,
                             capacity_before: box.capacity,
                             capacity_after: box.capacity,
                             scanned_at: scanned_at
      end
    end
  end

  private
    def storage_integrity
      errors.add(:new_storage_id, :inclusion) if storage_id == new_storage_id
    end
end
