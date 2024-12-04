class Machinery < ApplicationRecord
  belongs_to :packaged_product
  belongs_to :packing_machine
  belongs_to :material_asset

  validates_uniqueness_of :material_asset_id, scope: %i[ packaged_product_id packing_machine_id ]
  validates_presence_of :start_time, :end_time
  validates :count, presence: true, numericality: { only_integer: true }

  def performance
    duration_in_hours = (end_time - start_time) / 1.hour.to_f
    return 0 if duration_in_hours <= 0

    (count.to_f / duration_in_hours).to_i
  end

  def planning_performance
    containers = packing_machine.containers.where(material_asset_id: material_asset_id)
    return 0 if containers.empty?

    containers.first.performance.to_i
  end
end
