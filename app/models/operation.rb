class Operation < ApplicationRecord
  include Deactivatable

  belongs_to :journal
  has_many :fields, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :journal, case_sensitive: false }
end
