class Metric < ApplicationRecord
  belongs_to :step
  belongs_to :field

  validates_presence_of :value, allow_nil: true

  scope :ordered, -> { joins(:field).order(fields: { chain_order: :asc }) }

  scope :filter_by_batch, ->(batch_id) { joins(:step).where(steps: { batch_id: batch_id }) }

  def display_label
    field.name
  end
end
