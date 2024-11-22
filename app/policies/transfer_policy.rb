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
      user.admin? ||
        user_sanctioning_for?(record.new_storage) ||
        user_replacing_for?(record.new_storage, record.receiver_id)
    end

    def user_sanctioning_for?(storage)
      storage.warehousers.filter_by_duty(:sanctioning).where(user_id: user.id).count > 0
    end

    def user_replacing_for?(storage, receiver_id)
      storage.warehousers.filter_by_duty(:replacing).where(user_id: user.id, replaceable_id: receiver_id).count > 0
    end
end
