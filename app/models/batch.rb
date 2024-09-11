class Batch < ApplicationRecord
  include Progressable

  belongs_to :production_unit

  belongs_to :machiner, -> { User.filter_by_role(:machiner) }, class_name: "User", foreign_key: "machiner_id"
  belongs_to :tester,   -> { User.filter_by_role(:tester) },   class_name: "User", foreign_key: "tester_id"
  belongs_to :operator, -> { User.filter_by_role(:operator) }, class_name: "User", foreign_key: "operator_id"
  belongs_to :loader,   -> { User.filter_by_role(:loader) },   class_name: "User", foreign_key: "loader_id"

  has_many :steps, dependent: :destroy

  def progress
    10.0
  end

  def produced_sum
    0
  end

  def produced_tonnage
    0.0
  end

  def journals
    self.production_unit.group.journals
  end
end
