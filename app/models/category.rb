class Category < ApplicationRecord
  has_many :material_assets, dependent: :destroy
  has_many :groups, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  enum :kind, %i[ end_product material_asset raw_product packing ], default: :material_asset
  scope :filter_by_kind, ->(kind) { where(kind: kind) }

  scope :end_products, ->() { filter_by_kind(:end_product) }
  scope :material_assets, ->() { filter_by_kind(:material_asset) }
  scope :raw_products, ->() { filter_by_kind(:raw_product) }
  scope :packings, ->() { filter_by_kind(:packing) }
  scope :combined_assets, ->() { filter_by_kind(%i[ material_asset raw_product packing ]) }
end
