class Warehouser < ApplicationRecord
  include Deactivatable

  belongs_to :storage
  belongs_to :user
  belongs_to :replaceable, class_name: "User", foreign_key: "replaceable_id", optional: true

  enum :duty, %w[ executing sanctioning replacing ].index_by(&:itself), default: :executing

  before_validation :clear_replaceable, unless: :replacing?
  validates_uniqueness_of :user_id, scope: :storage_id
  validates_presence_of :replaceable_id, if: :replacing?

  scope :filter_by_duty, ->(duty) { where(duty: duty) }

  def user_name
    user.name
  end

  private
    def clear_replaceable
      self.replaceable_id = nil
    end
end
