class Batch < ApplicationRecord
  include Progressable

  belongs_to :production_unit
  has_one :group, through: :production_unit

  belongs_to :machiner, -> { User.filter_by_role(:machiner) }, class_name: "User", foreign_key: "machiner_id"
  belongs_to :tester,   -> { User.filter_by_role(:tester) },   class_name: "User", foreign_key: "tester_id"
  belongs_to :operator, -> { User.filter_by_role(:operator) }, class_name: "User", foreign_key: "operator_id"
  belongs_to :loader,   -> { User.filter_by_role(:loader) },   class_name: "User", foreign_key: "loader_id"

  belongs_to :storage, -> { for_material_assets }

  has_many :steps, dependent: :destroy

  has_one :packing, dependent: :destroy
  has_many :packaged_products, through: :packing, source: :products
  has_many :machineries, through: :packaged_products

  has_one :cooking, dependent: :destroy
  has_many :cooked_semi_products, through: :cooking, source: :semi_products

  has_one :distribution, dependent: :destroy
  has_many :distributed_products, through: :distribution, source: :products
  has_many :generations, through: :distributed_products
  has_many :box_requests, through: :generations

  has_many :waybills, -> { automatic }, dependent: :destroy

  enum :work_shift, %w[ daily night ].index_by(&:itself), default: :daily

  def progress
    (total_completed_steps.to_d / total_operations.to_d) * 100.0
  end

  def total_completed_steps(journal_id: nil, unordable: nil)
    base_scope = steps.finished
    base_scope = base_scope.filter_by_unordable(unordable) unless unordable.nil?
    base_scope = base_scope.filter_by_journal(journal_id) unless journal_id.nil?
    base_scope.count
  end

  def total_operations(journal_id: nil, unordable: nil)
    base_scope = production_unit.group.operations
    base_scope = base_scope.filter_by_unordable(unordable) unless unordable.nil?
    base_scope = base_scope.filter_by_journal(journal_id) unless journal_id.nil?
    base_scope.count
  end

  def produced_count
    if self.production_unit.plan.semi?
      cooked_semi_products.approved.count
    else
      packaged_products.approved.sum(:count)
    end
  end

  def produced_tonnage
    if self.production_unit.plan.semi?
      scope = self.cooked_semi_products.approved.filter_by_group(self.group.id)
      scope.sum(:litrage) / 1000.0
    else
      scope = self.packaged_products.filter_by_group(self.group.id)
      total = scope.sum("packaged_products.count * products.packing")
      total > 0.0 ? scope.first.product.measurement.to_tonnage_ratio(total) : 0.0
    end
  end

  def journals
    self.production_unit.group.journals.active
  end

  def completed_journal?(journal)
    total_completed_steps(journal_id: journal.id) == total_operations(journal_id: journal.id)
  end

  def completed_journals?(unordable: nil)
    total_completed_steps(unordable: unordable) == total_operations(unordable: unordable)
  end
end
