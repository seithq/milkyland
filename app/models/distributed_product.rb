class DistributedProduct < ApplicationRecord
  belongs_to :distribution
  belongs_to :packaged_product
  belongs_to :region

  validates_presence_of :production_date
  validates :count, presence: true, numericality: { only_integer: true }
end
