class Region < ApplicationRecord
  validates :name, :code, presence: true, uniqueness: { case_sensitive: false }

  scope :ordered, -> { order(code: :asc) }
end
