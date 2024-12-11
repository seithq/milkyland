class BankAccount < ApplicationRecord
  belongs_to :company
  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :company_id }
  validates_presence_of :number

  has_many :transactions, dependent: :destroy

  scope :main, -> { where(main: true) }

  validate :main_integrity

  private
    def main_integrity
      errors.add(:main, :taken) if main? && has_main?
    end

    def has_main?
      scope = BankAccount.main
      return false if scope.exists? self.id

      scope.count > 0
    end
end
