class PackingMachine < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :containers, dependent: :destroy
end
