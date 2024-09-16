class Step < ApplicationRecord
  include Progressable

  belongs_to :batch
  belongs_to :operation

  has_many :metrics, -> { ordered }, dependent: :destroy
  accepts_nested_attributes_for :metrics

  validates_uniqueness_of :operation_id, scope: :batch_id

  scope :filter_by_operation, ->(operation_id) { where(operation_id: operation_id) }

  scope :ordered, -> { joins(:operation).order(operations: { chain_order: :asc }) }

  def build_fields
    metrics.build(operation.fields.active.map { |field| { field: field } })
  end
end
