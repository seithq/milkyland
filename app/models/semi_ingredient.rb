class SemiIngredient < ApplicationRecord
  include Deactivatable

  belongs_to :group, touch: :recipe_modified_at
  belongs_to :semi_product

  validates_presence_of :ratio
end
