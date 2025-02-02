class ProductionUnit < ApplicationRecord
  include Progressable

  belongs_to :plan, inverse_of: :units
  belongs_to :group

  has_many :batches, dependent: :destroy

  has_many :packings, through: :batches
  has_many :packaged_products, through: :packings, source: :products

  has_many :cookings, through: :batches
  has_many :cooked_semi_products, through: :cookings, source: :semi_products

  validates_uniqueness_of :group_id, scope: :plan_id

  validates :count, presence: true, numericality: { only_integer: true }
  validates :tonnage, presence: true, numericality: { greater_than: 0.0 }

  def progress
    (produced_count.to_d / count.to_d) * 100
  end

  def produced_count
    if self.plan.semi?
      cooked_semi_products.approved.count
    else
      packaged_products.approved.sum(:count)
    end
  end

  def produced_tonnage
    if self.plan.semi?
      scope = self.cooked_semi_products.approved.filter_by_group(self.group_id)
      scope.sum(:litrage) / 1000.0
    else
      scope = self.packaged_products.approved.filter_by_group(self.group_id)
      total = scope.sum("packaged_products.count * products.packing")
      total > 0.0 ? scope.first.product.measurement.to_tonnage_ratio(total) : 0.0
    end
  end

  def ingredients
    self.group.ingredients.active
  end

  def semi_ingredients
    self.group.semi_ingredients.active
  end

  def has_required_components?
    if self.plan.semi?
      self.has_required_ingredients?
    else
      self.has_required_semi_ingredients? && self.has_required_ingredients?
    end
  end

  def has_required_ingredients?
    self.ingredients.each do |ingredient|
      _, _, satisfied = ingredient.calculate_availability_for self
      return false unless satisfied
    end
    true
  end

  def has_required_semi_ingredients?
    self.semi_ingredients.each do |semi_ingredient|
      _, _, satisfied = semi_ingredient.calculate_availability_for self
      return false unless satisfied
    end
    true
  end
end
