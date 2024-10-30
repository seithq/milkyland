module Codable
  extend ActiveSupport::Concern

  included do
    scope :filter_by_code, ->(code) { where("LOWER(code) LIKE ?", like(code)) }
  end
end
