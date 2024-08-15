class Measurement < ApplicationRecord
  has_many :material_assets, dependent: :destroy
  has_many :standards, dependent: :destroy

  validates_presence_of :name, :unit
  validates_uniqueness_of :unit

  def display_label
    "#{ name } (#{ unit })"
  end
end
