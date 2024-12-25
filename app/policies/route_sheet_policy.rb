class RouteSheetPolicy < ApplicationPolicy
  def edit?
    owned? && allowed_statuses?
  end

  def destroy?
    owned? && allowed_statuses? && ensure_not_generated?
  end

  def new_tracking?
    owned? && allowed_statuses? && ensure_not_generated? && !client_departure?
  end

  def new_order?
    owned? && allowed_statuses? && client_departure?
  end

  private
    def owned?
      user.can_ship?
    end

    def allowed_statuses?
      %w[ pending ready_to_collect ].include? record.status
    end

    def ensure_not_generated?
      return true unless record.shipment.plan.present?

      !record.generated?
    end

    def client_departure?
      record.shipment.client.present?
    end
end
