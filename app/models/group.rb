class Group < ApplicationRecord
  belongs_to :category

  has_rich_text :cooking_technology

  has_many :products, dependent: :destroy
  has_many :ingredients, dependent: :destroy

  has_many :semi_products, dependent: :destroy
  has_many :semi_ingredients, dependent: :destroy

  has_many :standards, dependent: :destroy
  has_many :journals, -> { ordered }, dependent: :destroy
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

  def copy
    new_group = self.dup
    new_group.name = "#{ self.name } - Copy #{ SecureRandom.hex(6) }"

    self.ingredients.each do |ingredient|
      new_ingredient = ingredient.dup
      new_group.ingredients << new_ingredient
    end

    self.semi_ingredients.each do |semi_ingredient|
      new_semi_ingredient = semi_ingredient.dup
      new_group.semi_ingredients << new_semi_ingredient
    end

    self.journals.each do |journal|
      new_journal = journal.dup
      journal.operations.each do |operation|
        new_operation = operation.dup
        operation.fields.each do |field|
          new_field = field.dup
          new_operation.fields << new_field
        end
        new_journal.operations << new_operation
      end
      new_group.journals << new_journal
    end

    new_group
  end
end
