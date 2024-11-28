class ShipmentPolicy < ApplicationPolicy
  def destroy?
    owned? &&
      not_auto_generated? &&
      not_completed? &&
      has_no_shipped_products?
  end

  private
    def not_completed?
      !record.new_record? && !record.completed?
    end

    def has_no_shipped_products?
      true
    end

    def not_auto_generated?
      !record.plan.present?
    end

    def owned?
      user.can_ship?
    end
end
