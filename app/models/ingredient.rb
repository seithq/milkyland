class Ingredient < ApplicationRecord
  belongs_to :group
  belongs_to :material_asset

  validates_presence_of :ratio

  scope :active, -> { where(active: true) }

  def deactivate
    update! active: false
  end
end
