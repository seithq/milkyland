class Operation < ApplicationRecord
  include Deactivatable

  belongs_to :journal
  has_many :fields, dependent: :destroy

  has_many :steps, -> { ordered }, dependent: :destroy
  has_many :metrics, -> { ordered }, through: :steps

  validates :name, presence: true, uniqueness: { scope: :journal, case_sensitive: false }

  scope :ordered, -> { merge(Journal.ordered).order(chain_order: :asc) }

  scope :filter_by_journal, ->(journal_id) { where(journal_id: journal_id) }
  scope :filter_by_unordable, ->(unordable) { joins(:journal).merge(Journal.filter_by_unordable(unordable)) }

  def name_with_journal
    "#{ journal.name } - #{ name }"
  end

  def name_with_index(index)
    "#{ index }. #{ name }"
  end

  def has_step?(batch)
    steps.where(batch: batch).count.positive?
  end

  def batch_steps(batch)
    steps.where(batch: batch)
  end

  def previous_step_completed_in?(batch)
    progression_map = progression_map batch
    progression_map[self.id][:previous]
  end

  private
    def progression_map(batch)
      progression = {}
      journal.operations.joins(:journal).ordered.each_with_index do |operation, index|
        completed = operation.batch_steps(batch).filter_by_status(%i[ completed cancelled ]).count.positive?

        previous = progression.select { |key, value| value[:index] == index - 1 }.first
        previous_completed = previous.present? ? previous.second[:completed] : false

        progression[operation.id] = {
          id: operation.id,
          index: index,
          chain_order: operation.chain_order,
          completed: completed,
          previous: index == 0 ? true : previous_completed
        }
      end
      progression
    end
end
