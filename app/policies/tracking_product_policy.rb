class TrackingProductPolicy < ApplicationPolicy
  def edit?
    owned? && allowed_statuses?
  end

  def adjust?
    return true if record.new_record?
    destroy?
  end

  def destroy?
    owned? && allowed_statuses? && ensure_not_generated? && !client_departure?
  end

  private
    def owned?
      user.can_ship?
    end

    def allowed_statuses?
      %w[ pending ready_to_collect ].include? record.route_sheet.status
    end

    def ensure_not_generated?
      return true unless record.route_sheet.shipment.plan.present?

      !record.route_sheet.generated?
    end

    def client_departure?
      record.route_sheet.shipment.client.present?
    end
end
