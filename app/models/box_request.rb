class BoxRequest < ApplicationRecord
  belongs_to :generation
  belongs_to :box_packaging

  has_many :boxes, dependent: :nullify

  validates :count, presence: true, numericality: { only_integer: true }

  scope :ordered, -> { joins(:box_packaging).order("box_packagings.count DESC") }
end
