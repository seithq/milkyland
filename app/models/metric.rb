class Metric < ApplicationRecord
  belongs_to :step
  belongs_to :field

  validates_presence_of :value, allow_nil: true

  scope :ordered, -> { joins(:field).order(fields: { chain_order: :asc }) }

  def display_label
    field.name
  end
end
