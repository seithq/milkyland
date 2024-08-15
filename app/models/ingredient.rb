class Ingredient < ApplicationRecord
  include Deactivatable

  belongs_to :group, touch: :recipe_modified_at
  belongs_to :material_asset

  validates_presence_of :ratio
end
