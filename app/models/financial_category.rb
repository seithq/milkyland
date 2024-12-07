class FinancialCategory < ApplicationRecord
  enum :kind, %w[ income expense ].index_by(&:itself)
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
