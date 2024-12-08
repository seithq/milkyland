class Article < ApplicationRecord
  include Directional

  belongs_to :financial_category
  belongs_to :activity_type

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :financial_category_id }
end
