module Deactivatable
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(active: true) }

    def deactivate
      update! active: false
    end
  end
end
