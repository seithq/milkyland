module User::Role
  extend ActiveSupport::Concern

  included do
    enum :role, %i[ admin manager launcher machiner tester operator loader warehouser ], default: :manager

    scope :filter_by_role, ->(role) { where(role: role) }

    scope :managers,  -> { filter_by_role(:manager) }
    scope :machiners, -> { filter_by_role(:machiner) }
    scope :testers,   -> { filter_by_role(:tester) }
    scope :operators, -> { filter_by_role(:operator) }
    scope :loaders,   -> { filter_by_role(:loader) }
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
end
