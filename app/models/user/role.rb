module User::Role
  extend ActiveSupport::Concern

  included do
    enum :role, %i[ admin manager ], default: :manager

    scope :filter_by_role, ->(role) { where(role: role) }
  end

  def can_administer?
    admin?
  end
end
