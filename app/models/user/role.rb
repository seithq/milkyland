module User::Role
  extend ActiveSupport::Concern

  included do
    enum :role, %i[ admin manager launcher machiner tester operator loader warehouser procurement_officer ], default: :manager

    scope :filter_by_role, ->(role) { where(role: role) }

    scope :managers,             -> { filter_by_role(:manager) }
    scope :machiners,            -> { filter_by_role(:machiner) }
    scope :testers,              -> { filter_by_role(:tester) }
    scope :operators,            -> { filter_by_role(:operator) }
    scope :loaders,              -> { filter_by_role(:loader) }
    scope :warehousers,          -> { filter_by_role(:warehouser) }
    scope :procurement_officers, -> { filter_by_role(:procurement_officer) }
  end

  def can_administer?
    admin?
  end

  def can_sell?
    can_administer? || manager?
  end

  def can_launch?
    can_administer? || launcher?
  end

  def can_store?
    can_administer? || warehouser?
  end

  def can_supply?
    can_administer? || procurement_officer?
  end
end
