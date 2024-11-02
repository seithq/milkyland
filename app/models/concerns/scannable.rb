module Scannable
  extend ActiveSupport::Concern

  included do
    def scan!(time: Time.zone.now)
      update! scanned_at: time
    end
  end
end
