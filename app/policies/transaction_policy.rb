class TransactionPolicy < ApplicationPolicy
  def create?
    user.admin? || user.finance_operator?
  end

  def update?
    owned? && record.pending?
  end

  def destroy?
    owned? && record.pending?
  end

  private
    def owned?
      user.admin? || record.creator_id == user.id
    end
end
