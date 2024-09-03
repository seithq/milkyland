class Consolidation < ApplicationRecord
  include Deactivatable

  belongs_to :plan
  belongs_to :order

  validates_uniqueness_of :order_id, scope: :plan_id

  scope :ordered, -> { order(created_at: :desc) }
end
