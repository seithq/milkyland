class Operation < ApplicationRecord
  include Deactivatable

  belongs_to :journal
  has_many :fields, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :journal, case_sensitive: false }

  scope :ordered, -> { merge(Journal.ordered).order(chain_order: :asc) }

  def name_with_journal
    "#{ journal.name } - #{ name }"
  end
end
