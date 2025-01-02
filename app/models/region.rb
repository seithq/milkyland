class Region < ApplicationRecord
  has_many :sales_points, dependent: :destroy
  has_many :distributed_products, dependent: :destroy

  has_many :boxes, dependent: :destroy

  has_many :shipments, dependent: :destroy

  has_many :sales_plans, dependent: :destroy

  validates :name, :code, presence: true, uniqueness: { case_sensitive: false }

  scope :ordered, -> { order(code: :asc) }
end
