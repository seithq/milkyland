class Step < ApplicationRecord
  include Progressable

  belongs_to :batch
  belongs_to :operation

  has_many :metrics, -> { ordered }, dependent: :destroy
  accepts_nested_attributes_for :metrics

  validates_uniqueness_of :operation_id, scope: :batch_id

  def build_fields
    metrics.build(operation.fields.active.map { |field| { field: field } })
  end
end
