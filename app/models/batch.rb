class Batch < ApplicationRecord
  include Progressable

  belongs_to :production_unit
  has_many :groups, through: :production_unit

  belongs_to :machiner, -> { User.filter_by_role(:machiner) }, class_name: "User", foreign_key: "machiner_id"
  belongs_to :tester,   -> { User.filter_by_role(:tester) },   class_name: "User", foreign_key: "tester_id"
  belongs_to :operator, -> { User.filter_by_role(:operator) }, class_name: "User", foreign_key: "operator_id"
  belongs_to :loader,   -> { User.filter_by_role(:loader) },   class_name: "User", foreign_key: "loader_id"

  has_many :steps, dependent: :destroy

  has_one :packing, dependent: :destroy
  has_many :packaged_products, through: :packing, source: :products

  has_one :distribution, dependent: :destroy
  has_many :distributed_products, through: :distribution, source: :products

  enum :work_shift, %w[ daily night ].index_by(&:itself), default: :daily

  def progress
    (total_completed_steps.to_d / total_operations.to_d) * 100.0
  end

  def total_completed_steps(journal_id: nil)
    base_scope = steps.filter_by_status(%i[ completed cancelled ])
    base_scope = base_scope.filter_by_journal(journal_id) unless journal_id.nil?
    base_scope.count
  end

  def total_operations(journal_id: nil)
    base_scope = production_unit.group.operations
    base_scope = base_scope.filter_by_journal(journal_id) unless journal_id.nil?
    base_scope.count
  end

  def produced_count
    packaged_products.approved.sum(:count)
  end

  def produced_tonnage
    scope = self.packaged_products.filter_by_group(groups.pluck(:id))
    total = scope.sum("packaged_products.count * products.packing")
    total > 0.0 ? scope.first.product.measurement.to_tonnage_ratio(total) : 0.0
  end

  def journals
    self.production_unit.group.journals.active
  end

  def completed_journal?(journal)
    total_completed_steps(journal_id: journal.id) == total_operations(journal_id: journal.id)
  end

  def completed_journals?
    total_completed_steps == total_operations
  end
end
