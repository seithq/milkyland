class BoxPackaging < ApplicationRecord
  include Deactivatable

  belongs_to :product
  belongs_to :material_asset, -> { group_packings }

  validates_uniqueness_of :material_asset_id, scope: :product_id
  validates :count, presence: true, numericality: { only_integer: true }
end
