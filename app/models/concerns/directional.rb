module Directional
  extend ActiveSupport::Concern

  included do
    enum :kind, %w[ income expense ].index_by(&:itself)
    scope :filter_by_kind, ->(kind) { where(kind: kind) }
  end
end
