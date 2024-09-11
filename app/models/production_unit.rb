class ProductionUnit < ApplicationRecord
  include Progressable

  belongs_to :plan
  belongs_to :group

  has_many :batches, dependent: :destroy

  validates_uniqueness_of :group_id, scope: :plan_id

  validates :count, presence: true, numericality: { only_integer: true }
  validates :tonnage, presence: true, numericality: { greater_than: 0.0 }

  def progress
    20.0
  end
end
