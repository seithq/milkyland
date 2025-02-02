class Storage < ApplicationRecord
  include Locatable

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :out_waybills, class_name: "Waybill", foreign_key: "storage_id",     dependent: :nullify
  has_many :in_waybills,  class_name: "Waybill", foreign_key: "new_storage_id", dependent: :nullify

  has_many :leftovers, dependent: :destroy

  has_many :products, through: :leftovers, source: :subject, source_type: "Product"
  has_many :semi_products, through: :leftovers, source: :subject, source_type: "SemiProduct"
  has_many :material_assets, through: :leftovers, source: :subject, source_type: "MaterialAsset"

  has_many :batches, dependent: :destroy

  has_many :zones, -> { ordered }, through: :elements, source: :storable, source_type: "Zone"

  has_many :holding_zones, -> { filter_by_kind(:hold).ordered }, through: :elements, source: :storable, source_type: "Zone"
  has_many :pallets, through: :holding_zones, source: :pallets
  has_many :boxes, through: :holding_zones, source: :boxes
  has_many :boxes_in_pallets, through: :holding_zones, source: :boxes_in_pallets
  has_many :lines, through: :holding_zones
  has_many :stacks, through: :lines
  has_many :tiers, through: :stacks
  has_many :pallets_in_tiers, through: :tiers, source: :pallets
  has_many :boxes_in_tiers, through: :tiers, source: :boxes
  has_many :boxes_in_tiers_in_pallets, through: :tiers, source: :boxes_in_pallets

  has_many :warehousers, dependent: :destroy

  has_many :returns, dependent: :destroy

  enum :kind, %w[ for_material_assets for_masters_material_assets for_masters for_goods ].index_by(&:itself), default: :for_goods

  scope :filter_by_name, ->(name) { where("LOWER(name) LIKE ?", like(name)) }
  scope :filter_by_kind, ->(kind) { where(kind: kind) }

  scope :for_material_assets, ->() { filter_by_kind(%i[ for_material_assets for_masters_material_assets ]) }
  scope :for_goods, ->() { filter_by_kind(%i[ for_masters for_goods ]) }

  scope :acceptable, ->() { for_goods.joins(:zones).merge(Zone.filter_by_kind(:arrival)) }

  scope :for_batches, ->() { filter_by_kind(:for_masters_material_assets) }

  def available_count(subject)
    leftovers.filter_by_subject(subject).sum(:count)
  end

  def display_index
    self.id
  end

  def caption_key
    self.model_name.singular
  end

  def for_assets?
    for_material_assets? || for_masters_material_assets?
  end

  private
    def pallet_scopes
      [ pallets, pallets_in_tiers ]
    end

    def box_scopes
      [ boxes, boxes_in_pallets, boxes_in_tiers, boxes_in_tiers_in_pallets ]
    end
end
