class RouteSheet < ApplicationRecord
  belongs_to :shipment, touch: :routes_changed_at

  has_many :tracking_products, dependent: :destroy
  has_many :products, through: :tracking_products

  has_many :assemblies, dependent: :destroy

  validates_presence_of :vehicle_plate_number, :driver_name, :driver_phone_number, on: :update
  validates_format_of :driver_phone_number, with: /\A\+[0-9]+[0-9]{3}[0-9]{7}\z/, allow_blank: true, on: :update

  enum :status, %w[ pending ready_to_collect completed ].index_by(&:itself), default: :pending

  scope :filter_by_status, ->(status) { where(status: status) }
  scope :for_mobile, ->() { filter_by_status(:ready_to_collect) }

  def display_label
    "#{ I18n.l(shipment.shipping_date) } - #{ vehicle_plate_number }"
  end
end
