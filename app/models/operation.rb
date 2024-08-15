class Operation < ApplicationRecord
  include Deactivatable

  belongs_to :journal

  validates :name, presence: true, uniqueness: { scope: :journal, case_sensitive: false }
end
