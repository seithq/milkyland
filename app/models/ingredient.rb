class Ingredient < ApplicationRecord
  include Deactivatable

  belongs_to :group, touch: :recipe_modified_at
  belongs_to :material_asset

  validates_presence_of :ratio

  def calculate_availability_for(production_unit, storage_id = Storage.for_batches.pluck(:id))
    required  = self.ratio * production_unit.tonnage
    available = self.material_asset.available_count(storage_id)
    satisfied = available >= required
    [ required, available, satisfied ]
  end
end
