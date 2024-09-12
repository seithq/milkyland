class Operation < ApplicationRecord
  include Deactivatable

  belongs_to :journal
  has_many :fields, dependent: :destroy

  has_many :steps, dependent: :destroy
  has_many :metrics, -> { ordered }, through: :steps

  validates :name, presence: true, uniqueness: { scope: :journal, case_sensitive: false }

  scope :ordered, -> { merge(Journal.ordered).order(chain_order: :asc) }

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
end
