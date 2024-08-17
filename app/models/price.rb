class Price < ApplicationRecord
  include Deactivatable

  belongs_to :product
  belongs_to :sales_channel

  validates :value, presence: true, numericality: { greater_than: 0.0 }
  validates_uniqueness_of :sales_channel_id, scope: :product_id
end
