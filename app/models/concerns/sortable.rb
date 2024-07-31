module Sortable
  extend ActiveSupport::Concern

  included do
    scope :recent_first, ->() { order(created_at: :desc) }

    def self.like(query)
      "%#{query.downcase}%"
    end
  end
end
