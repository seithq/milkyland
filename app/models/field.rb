class Field < ApplicationRecord
  include Deactivatable

  belongs_to :operation
  belongs_to :measurement, optional: true
  belongs_to :standard, optional: true

  has_many :metrics, dependent: :destroy

  enum :kind, %w[ date time binary measure normal collection ].index_by(&:itself)
  enum :collection, %w[ unset packing_machine ].index_by(&:itself), default: :unset

  validates :name, presence: true, uniqueness: { scope: :operation, case_sensitive: false }
  validates_presence_of :measurement_id, if: :measure?
  validates_presence_of :standard_id, if: :normal?

  scope :ordered, -> { merge(Operation.ordered).order(chain_order: :asc) }
end
