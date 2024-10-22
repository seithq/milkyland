module Sortable
  extend ActiveSupport::Concern

  included do
    scope :recent_first, ->() { order(created_at: :desc) }

    scope :filter_by_start_date, ->(start_date) { where(created_at: start_date.to_datetime.beginning_of_day..) }
    scope :filter_by_end_date,   ->(end_date)   { where(created_at: ..end_date.to_datetime.end_of_day) }

    def self.like(query)
      "%#{query.downcase}%"
    end
  end
end
