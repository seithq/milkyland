class BankAccount < ApplicationRecord
  belongs_to :company
  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :company_id }
  validates_presence_of :number
end
