class Group < ApplicationRecord
  belongs_to :category

  has_rich_text :cooking_technology

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :metric_tonne, presence: true, numericality: { only_integer: true }
end
