class Plan < ApplicationRecord
  validates :production_date, presence: true, comparison: { greater_than_or_equal_to: Time.zone.today }

  enum :status, %w[ in_consolidation in_production completed cancelled ].index_by(&:itself), default: :in_consolidation

  scope :ordered, -> { order(production_date: :desc) }

  def self.after(from_date)
    Plan.where(status: :in_consolidation, production_date: (from_date + 1.day)..).order(production_date: :asc).first
  end

  def cancel
    update! status: :cancelled
  end
end
