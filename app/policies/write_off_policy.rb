class WriteOffPolicy < ApplicationPolicy
  def edit?
    owned? && record.draft?
  end

  def scan?
    edit? && !record.new_record?
  end

  def destroy?
    scan?
  end

  private
    def owned?
      user.admin? || (user.id == record.sender_id)
    end
end
