class Group < ApplicationRecord
  belongs_to :category

  has_rich_text :cooking_technology

  has_many :products, dependent: :destroy
  has_many :ingredients, dependent: :destroy

  has_many :semi_products, dependent: :destroy
  has_many :semi_ingredients, dependent: :destroy

  has_many :standards, dependent: :destroy
  has_many :journals, -> { active.ordered }, dependent: :destroy
  has_many :operations, -> { active.ordered }, through: :journals
  has_many :fields, -> { active.ordered }, through: :operations

  has_many :units, class_name: "ProductionUnit", foreign_key: "group_id", dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :metric_tonne, presence: true, numericality: { only_integer: true }

  scope :ordered, -> { order(name: :asc) }

  scope :end_products, ->() { joins(:category).merge(Category.end_products) }
  scope :semi_products, ->() { joins(:category).merge(Category.semi_products) }

  def available_trackable_fields(field)
    base_scope = self.fields.filter_by_trigger(:on_start)
    return base_scope if field.new_record?

    base_scope.filter_by_operation(field.operation_id)
  end
end
