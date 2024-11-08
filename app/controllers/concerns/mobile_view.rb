module MobileView
  extend ActiveSupport::Concern

  included do
    layout "mobile"
  end
end
