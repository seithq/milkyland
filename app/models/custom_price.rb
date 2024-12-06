class CustomPrice < ApplicationRecord
  include Deactivatable

  belongs_to :product
  belongs_to :client

  validates :value, presence: true, numericality: { greater_than: 0.0 }
  validates_uniqueness_of :client_id, scope: :product_id
end
