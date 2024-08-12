class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  enum :kind, %i[ end_product material_asset ], default: :asset
  scope :filter_by_kind, ->(kind) { where(kind: kind) }

  scope :end_products, ->() { filter_by_kind(:end_product) }
  scope :material_assets, ->() { filter_by_kind(:material_asset) }
end
