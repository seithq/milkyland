class Field < ApplicationRecord
  include Deactivatable

  belongs_to :operation

  enum :kind, %w[ date time range binary measure collection ].index_by(&:itself)

  validates :name, presence: true, uniqueness: { scope: :operation, case_sensitive: false }

  scope :ordered, -> { merge(Operation.ordered).order(chain_order: :asc) }
end
