class ProductionUnit < ApplicationRecord
  include Progressable

  belongs_to :plan
  belongs_to :group

  has_many :batches, dependent: :destroy

  has_many :packings, through: :batches
  has_many :packaged_products, through: :packings, source: :products

  validates_uniqueness_of :group_id, scope: :plan_id

  validates :count, presence: true, numericality: { only_integer: true }
  validates :tonnage, presence: true, numericality: { greater_than: 0.0 }

  def progress
    (produced_count.to_d / count.to_d) * 100
  end

  def produced_count
    packaged_products.approved.sum(:count)
  end

  def produced_tonnage
    scope = self.packaged_products.approved.filter_by_group(self.group_id)
    total = scope.sum("packaged_products.count * products.packing")
    total > 0.0 ? scope.first.product.measurement.to_tonnage_ratio(total) : 0.0
  end

  def ingredients
    self.group.ingredients.active
  end
end
