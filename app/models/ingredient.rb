class Ingredient < ApplicationRecord
  belongs_to :group, touch: :recipe_modified_at
  belongs_to :material_asset

  validates_presence_of :ratio

  scope :active, -> { where(active: true) }

  def deactivate
    update! active: false
  end
end
