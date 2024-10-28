class Storage < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :out_waybills, class_name: "Waybill", foreign_key: "storage_id",     dependent: :nullify
  has_many :in_waybills,  class_name: "Waybill", foreign_key: "new_storage_id", dependent: :nullify

  has_many :leftovers, dependent: :destroy

  enum :kind, %w[ for_material_assets for_masters for_goods ].index_by(&:itself), default: :for_goods

  scope :filter_by_name, ->(name) { where("LOWER(name) LIKE ?", like(name)) }
  scope :filter_by_kind, ->(kind) { where(kind: kind) }

  scope :for_material_assets, ->() { filter_by_kind(:for_material_assets) }

  def available_count(subject)
    leftovers.filter_by_subject(subject).sum(:count)
  end
end
