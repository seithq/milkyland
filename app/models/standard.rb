class Standard < ApplicationRecord
  include Deactivatable

  belongs_to :group
  belongs_to :measurement

  validates :name, presence: true, uniqueness: { scope: :group, case_sensitive: false }
  validates :from, :to, presence: true, numericality: { only_integer: true }

  def passed?(value)
    from <= value && value <= to
  end
end
