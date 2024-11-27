class SemiProduct < ApplicationRecord
  belongs_to :group
  belongs_to :measurement

  has_many :semi_ingredients, dependent: :destroy

  has_many :leftovers, as: :subject, dependent: :destroy
  has_many :storages, through: :leftovers

  has_many :cooked_semi_products, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates_presence_of :expiration_in_days

  scope :filter_by_group, ->(group_id) { where(group_id: group_id) }

  scope :ordered, -> { order(name: :asc) }

  def available_count(storage_id = nil)
    base_scope = leftovers
    base_scope = base_scope.filter_by_storage(storage_id) unless storage_id.nil?
    base_scope.sum(:count)
  end
end
