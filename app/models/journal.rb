class Journal < ApplicationRecord
  include Deactivatable

  belongs_to :group

  has_many :operations, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :group, case_sensitive: false }
end
