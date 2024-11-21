class TransferPolicy < ApplicationPolicy
  def edit?
    owned? && record.draft?
  end

  def scan?
    edit? && !record.new_record?
  end

  def destroy?
    scan?
  end

  def approve?
    assigned? && !record.new_record? && record.reload.pending?
  end

  def sanction?
    privileged? && !record.new_record? && record.reload.pending?
  end

  private
    def owned?
      user.admin? || (user.id == record.sender_id)
    end

    def assigned?
      user.admin? || (user.id == record.receiver_id)
    end

    def privileged?
      # TODO: add warehouser extended role
      user.admin?
    end
end
