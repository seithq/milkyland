class Journal < ApplicationRecord
  include Deactivatable

  belongs_to :group

  has_many :operations, dependent: :destroy
  has_many :fields, through: :operations

  validates :name, presence: true, uniqueness: { scope: :group, case_sensitive: false }

  scope :ordered, -> { order(chain_order: :asc) }
end
