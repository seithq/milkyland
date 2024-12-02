class Shipment < ApplicationRecord
  belongs_to :plan, optional: true
  belongs_to :region
  belongs_to :client, optional: true

  has_many :route_sheets, dependent: :destroy

  before_validation :clear_client, if: :internal?

  validates_presence_of :shipping_date
  validates_presence_of :client_id, if: :external?

  after_update :update_route_sheets
  after_touch :ensure_status_changed

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

  def has_custom_fifo?
    external? && client.fifo_in_days > 0
  end

  private
    def clear_client
      self.client = nil
    end

    def update_route_sheets
      changeable_statuses = %w[ pending ready_to_collect ]
      if status_previously_changed? && changeable_statuses.include?(status)
        route_sheets.filter_by_status(changeable_statuses).update_all(status: status)
      end
    end

    def ensure_status_changed
      update status: :completed if all_route_sheets_completed?
    end

    def all_route_sheets_completed?
      return false if route_sheets.count.zero?
      route_sheets.filter_by_status(:completed).count == route_sheets.count
    end
end
