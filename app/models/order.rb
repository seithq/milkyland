class Order < ApplicationRecord
  belongs_to :sales_channel
  belongs_to :client
  belongs_to :sales_point

  enum :kind, %i[ planned unscheduled ], default: :planned
  enum :status, %w[ in_planning in_production in_delivery completed cancelled ].index_by(&:itself), default: :in_planning

  def cancel
    update! status: :cancelled
  end
end
