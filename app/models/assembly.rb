class Assembly < ApplicationRecord
  belongs_to :route_sheet
  belongs_to :zone
  belongs_to :user

  enum :status, %w[ draft approved ].index_by(&:itself), default: :draft
end
