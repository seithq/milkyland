class Region < ApplicationRecord
  has_many :sales_points, dependent: :destroy

  validates :name, :code, presence: true, uniqueness: { case_sensitive: false }

  scope :ordered, -> { order(code: :asc) }
end
