class Return < ApplicationRecord
  belongs_to :user
  belongs_to :order
  belongs_to :storage
  belongs_to :accepting_user, class_name: "User", foreign_key: "accepting_user_id", optional: true

  has_many :returned_products, dependent: :destroy

  enum :status, %w[ draft approved ].index_by(&:itself), default: :draft

  scope :filter_by_user, ->(user_id) { where user_id: user_id }
  scope :filter_by_order, ->(order_id) { where order_id: order_id }
  scope :filter_by_status, ->(status) { where status: status }
  scope :filter_by_storage, ->(storage_id) { where storage_id: storage_id }
end
