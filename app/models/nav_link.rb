class NavLink
  include ActiveModel::Model

  attr_accessor :path, :title, :icon_name, :is_active
end
