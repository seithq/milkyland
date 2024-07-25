module User::Role
  extend ActiveSupport::Concern

  included do
    enum :role, %i[ admin member ], default: :member
  end

  def can_administer?
    admin?
  end
end
