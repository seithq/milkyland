class Standard < ApplicationRecord
  include Deactivatable

  belongs_to :group
  belongs_to :measurement

  has_many :fields, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :group, case_sensitive: false }
  validates_presence_of :from, :to

  def passed?(value)
    from <= value && value <= to
  end
end
