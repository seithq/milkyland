class Journal < ApplicationRecord
  include Deactivatable

  belongs_to :group

  has_many :operations, dependent: :destroy
  has_many :fields, through: :operations

  validates :name, presence: true, uniqueness: { scope: :group, case_sensitive: false }

  scope :ordered, -> { order(chain_order: :asc) }
  scope :filter_by_unordable, ->(unordable) { where(unordable: unordable) }

  scope :before_packing_or_cooking, -> { filter_by_unordable(false) }
  scope :after_packing_or_cooking, -> { filter_by_unordable(true) }
end
