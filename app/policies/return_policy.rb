class ReturnPolicy < ApplicationPolicy
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
    user.can_ship?
  end

  def edit?
    update?
  end

  def update?
    owned? && record.draft? && !record.new_record?
  end

  def destroy?
    owned? && record.draft? && !record.new_record?
  end

  relation_scope do |relation|
    next relation if user.admin?
    Return.filter_by_storage user.storages.for_goods.acceptable
  end

  private
    def owned?
      user.admin? || (user.id == record.user_id)
    end
end
