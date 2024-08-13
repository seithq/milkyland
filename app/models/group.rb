class Group < ApplicationRecord
  belongs_to :category

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :metric_tonne, presence: true, numericality: { only_integer: true }
end
