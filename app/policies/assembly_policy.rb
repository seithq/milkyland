class AssemblyPolicy < ApplicationPolicy
  def edit?
    owned? && record.draft?
  end

  def scan?
    edit? && !record.new_record?
  end

  def destroy?
    scan?
  end

  relation_scope do |relation|
    next relation if user.admin?
    user.assemblies
  end

  private
    def owned?
      user.admin? || (user.id == record.user_id)
    end
end
