class SemiProduct < ApplicationRecord
  belongs_to :group
  belongs_to :measurement

  has_many :semi_ingredients, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates_presence_of :expiration_in_days

  scope :filter_by_group, ->(group_id) { where(group_id: group_id) }

  scope :ordered, -> { order(name: :asc) }
end
