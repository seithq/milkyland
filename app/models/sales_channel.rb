class SalesChannel < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :prices, dependent: :destroy

  scope :ordered, -> { order(name: :asc) }
end
