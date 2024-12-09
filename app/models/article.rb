class Article < ApplicationRecord
  include Directional

  belongs_to :financial_category
  belongs_to :activity_type

  has_many :transactions, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :financial_category_id }
  validate :system_integrity, on: :create

  scope :systems, ->(kind) { filter_by_kind(kind).where(system: true) }

  private
    def system_integrity
      errors.add(:system, :taken) if system? && has_system_for?(self.kind)
    end

    def has_system_for?(kind)
      Article.systems(kind).count > 0
    end
end
