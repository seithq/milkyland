class PackingMachine < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :machineries, dependent: :destroy

  has_many :containers, dependent: :destroy
  has_many :material_assets, through: :containers
end
