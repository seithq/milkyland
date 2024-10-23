class Waybill < ApplicationRecord
  include Deactivatable

  belongs_to :storage, optional: true
  belongs_to :new_storage, class_name: "Storage", foreign_key: "new_storage_id", optional: true

  belongs_to :sender, class_name: "User", foreign_key: "sender_id", optional: true
  belongs_to :receiver, class_name: "User", foreign_key: "receiver_id", optional: true

  belongs_to :batch, optional: true

  has_many :leftovers, dependent: :destroy

  enum :kind, %w[ arrival departure transfer write_off production_write_off return_back ].index_by(&:itself)

  validates_presence_of :storage_id, unless: ->() { arrival? }
  validates_presence_of :new_storage_id, if: ->() { arrival? || transfer? || return_back? }
  validates_presence_of :batch_id, if: :production_write_off?

  validate :storage_integrity

  scope :filter_by_kind, ->(kind) { where(kind: kind) }
  scope :automatic, ->() { filter_by_kind(:production_write_off) }

  scope :for_material_assets, ->() { left_joins(:storage).left_joins(:new_storage).where(storages: { kind: :for_material_assets }).or(where(new_storages_waybills: { kind: :for_material_assets })) }

  def editable?
    self.new_record? && self.active?
  end

  private
    def storage_integrity
      errors.add(:new_storage_id, :inclusion) if storage_id == new_storage_id
    end
end
