class MaterialAsset < ApplicationRecord
  belongs_to :category
  belongs_to :supplier
  belongs_to :measurement

  validates :article, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true, uniqueness: { scope: :supplier, case_sensitive: false }
end
