class Field < ApplicationRecord
  include Deactivatable

  belongs_to :operation
  belongs_to :measurement, optional: true
  belongs_to :standard, optional: true

  belongs_to :trackable, class_name: "Field", foreign_key: "trackable_id", optional: true
  has_one :trackers, class_name: "Field", foreign_key: "trackable_id", dependent: :nullify

  has_many :metrics, dependent: :destroy

  enum :kind, %w[ date time binary measure normal collection ].index_by(&:itself)
  enum :collection, %w[ unset packing_machine ].index_by(&:itself), default: :unset
  enum :trigger, %w[ on_save on_start on_stop ].index_by(&:itself), default: :on_save, prefix: true

  before_validation :discard_trigger, unless: :time?
  before_validation :discard_tracker, unless: :trigger_on_stop?

  validates :name, presence: true, uniqueness: { scope: :operation, case_sensitive: false }
  validates_presence_of :measurement_id, if: :measure?
  validates_presence_of :standard_id, if: :normal?

  scope :ordered, -> { merge(Operation.ordered).order(chain_order: :asc) }
  scope :filter_by_trigger, ->(trigger) { where(trigger: trigger) }
  scope :filter_by_operation, ->(operation_id) { where(operation: operation_id) }

  def should_apply_time_window?
    time? && trackable.present? && time_window?
  end

  def valid_time_window_for?(step, stop_time)
    return true unless should_apply_time_window?

    trackable_metrics = step.metrics.filter_by_trackable trackable_id
    return true if trackable_metrics.count.zero?

    trackable_metric = trackable_metrics.first
    start_time = trackable_metric.value.blank? ? step.created_at : Time.zone.parse(trackable_metric.value)

    delta_in_min = (stop_time - start_time) / 1.minute
    delta_in_min < time_window.to_f
  end

  def name_with_operation
    "#{ operation.name } - #{ name }"
  end

  private
    def discard_trigger
      self.trigger = :on_save
    end

    def discard_tracker
      self.trackable = nil
    end
end
