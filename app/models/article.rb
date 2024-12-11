class Article < ApplicationRecord
  include Directional

  belongs_to :financial_category
  belongs_to :activity_type

  has_many :transactions, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :financial_category_id }
  validate :system_integrity
  validate :suppliable_integrity

  scope :systems, ->(kind) { filter_by_kind(kind).where(system: true) }
  scope :suppliables, -> { filter_by_kind(:expense).where(suppliable: true) }

  private
    def system_integrity
      errors.add(:system, :taken) if system? && has_system_for?(self.kind)
    end

    def has_system_for?(kind)
      scope = Article.systems(kind)
      return false if scope.exists? self.id

      scope.count > 0
    end

    def suppliable_integrity
      errors.add(:suppliable, :taken) if suppliable? && has_suppliable?
    end

    def has_suppliable?
      scope = Article.suppliables
      return false if scope.exists? self.id

      scope.count > 0
    end
end
