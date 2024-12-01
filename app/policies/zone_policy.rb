class ZonePolicy < ApplicationPolicy
  scope_for :relation, :mobile do |relation|
    (user.admin? ? relation : user.zones).for_mobile
  end
end
