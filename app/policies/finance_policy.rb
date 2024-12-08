class FinancePolicy < ApplicationPolicy
  def index?
    owned?
  end

  private
    def owned?
      user.admin? || %w[ finance_operator finance_controller accountant ].include?(user.role)
    end
end
