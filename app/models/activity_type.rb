class ActivityType < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates_presence_of :order_number

  has_many :articles, dependent: :destroy
end
