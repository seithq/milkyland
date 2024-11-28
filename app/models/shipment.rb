class Shipment < ApplicationRecord
  belongs_to :plan, optional: true
  belongs_to :region
  belongs_to :client, optional: true

  before_validation :clear_client, if: :internal?

  validates_presence_of :shipping_date
  validates_presence_of :client_id, if: :external?

  enum :kind, %w[ internal external ].index_by(&:itself), default: :internal
  enum :status, %w[ pending ready_to_collect completed ].index_by(&:itself), default: :pending

  scope :filter_by_kind, ->(kind) { where(kind: kind) }
  scope :filter_by_status, ->(status) { where(status: status) }
  scope :filter_by_region, ->(region_id) { where(region_id: region_id) }
  scope :filter_by_client, ->(client_id) { where(client_id: client_id) }

  scope :ordered, -> { order(shipping_date: :asc) }

  def clients
    plan.present? ? plan.clients : Client.ordered
  end

  private
    def clear_client
      self.client = nil
    end
end
