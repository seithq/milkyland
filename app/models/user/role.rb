module User::Role
  extend ActiveSupport::Concern

  included do
    enum :role, %i[ admin manager launcher ], default: :manager

    scope :filter_by_role, ->(role) { where(role: role) }
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
end
