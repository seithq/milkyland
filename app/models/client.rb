class Client < ApplicationRecord
  include Entitable, Binable

  has_many :sales_points, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :shipments, dependent: :destroy
  has_many :custom_prices, dependent: :destroy

  scope :ordered, -> { order(name: :asc) }
end
