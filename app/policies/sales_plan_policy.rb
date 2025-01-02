class SalesPlanPolicy < ApplicationPolicy
  def index?
    create?
  end

  def show?
    create?
  end

  def new?
    create?
  end

  def create?
    owned?
  end

  def edit?
    update?
  end

  def update?
    owned? && !record.new_record? && record.month >= Date.current.beginning_of_month
  end

  def destroy?
    update?
  end

  private
    def owned?
      user.admin? || user.can_sell?
    end
end
