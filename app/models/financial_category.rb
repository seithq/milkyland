class FinancialCategory < ApplicationRecord
  include Directional

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :articles, dependent: :destroy
end
