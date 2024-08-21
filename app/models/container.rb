class Container < ApplicationRecord
  include Deactivatable

  belongs_to :packing_machine
  belongs_to :material_asset

  validates_uniqueness_of :material_asset_id, scope: :packing_machine_id
  validates :performance, :losses_percentage, presence: true, numericality: { greater_than: 0.0 }
end
