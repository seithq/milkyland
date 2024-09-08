class Group < ApplicationRecord
  belongs_to :category

  has_rich_text :cooking_technology

  has_many :products, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  has_many :standards, dependent: :destroy

  has_many :journals, -> { ordered }, dependent: :destroy
  has_many :operations, -> { ordered }, through: :journals
  has_many :fields, -> { ordered }, through: :operations

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :metric_tonne, presence: true, numericality: { only_integer: true }

  scope :ordered, -> { order(name: :asc) }
end
