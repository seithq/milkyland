class CompanyPolicy < ApplicationPolicy
  def destroy?
    owned? && has_empty_associations?
  end

  private
    def owned?
      user.admin?
    end

    def has_empty_associations?
      true
    end
end
