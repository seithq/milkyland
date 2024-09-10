module ProductionView
  extend ActiveSupport::Concern

  included do
    layout "production"
  end
end
