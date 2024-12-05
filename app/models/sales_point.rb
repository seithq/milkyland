class SalesPoint < ApplicationRecord
  include Deactivatable

  belongs_to :client
  belongs_to :region
  has_many :orders, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :client, case_sensitive: false }
  validates_presence_of :address
  validates_format_of :phone_number, with: /\A\+[0-9]+[0-9]{3}[0-9]{7}\z/, allow_blank: true

  scope :filter_by_region, ->(region_id) { where(region_id: region_id) }
end
