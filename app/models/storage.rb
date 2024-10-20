class Storage < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  enum :kind, %i[ for_material_assets for_masters for_goods ], default: :for_goods
end
