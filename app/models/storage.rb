class Storage < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  enum :kind, %w[ for_material_assets for_masters for_goods ].index_by(&:itself), default: :for_goods

  scope :filter_by_name, ->(name) { where("LOWER(name) LIKE ?", like(name)) }
  scope :filter_by_kind, ->(kind) { where(kind: kind) }
end
