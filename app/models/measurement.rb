class Measurement < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :material_assets, dependent: :destroy
  has_many :standards, dependent: :destroy
  has_many :containers, dependent: :destroy

  validates_presence_of :name, :unit
  validates_uniqueness_of :unit

  def display_label
    "#{ name } (#{ unit })"
  end
end
