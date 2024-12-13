class TransactionPolicy < ApplicationPolicy
  def create?
    user.admin? || user.finance_operator?
  end

  def update?
    can_modify_pending?
  end

  def approve?
    confirm? || complete?
  end

  def confirm?
    can_confirm?
  end

  def complete?
    can_complete?
  end

  def destroy?
    can_modify_pending?
  end

  def view_confirm?
    user.admin? || user.finance_controller?
  end

  def view_complete?
    user.admin? || user.accountant?
  end

  private
    def owned?
      user.admin? || record.creator_id == user.id
    end

    def can_modify_pending?
      owned? && record.pending?
    end

    def can_confirm?
      (user.admin? || user.finance_controller?) && record.reload.pending?
    end

    def can_complete?
      (user.admin? || user.accountant?) && record.reload.confirmed?
    end
end
