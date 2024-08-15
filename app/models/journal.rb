class Journal < ApplicationRecord
  include Deactivatable

  belongs_to :group

  validates :name, presence: true, uniqueness: { scope: :group, case_sensitive: false }
end
