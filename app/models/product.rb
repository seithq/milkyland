class Product < ApplicationRecord
  belongs_to :group
  belongs_to :measurement
  belongs_to :material_asset, -> { packings }

  validates :name, :article, presence: true, uniqueness: { case_sensitive: false }
  validates_presence_of :packing, :expiration_in_days, :fat_fraction
  validates_numericality_of :fat_fraction, in: 0.0..100.0
end
