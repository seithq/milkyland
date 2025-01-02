class SalesChannel < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :prices, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :estimations, dependent: :destroy

  scope :ordered, -> { order(name: :asc) }
end
