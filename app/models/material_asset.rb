class MaterialAsset < ApplicationRecord
  belongs_to :category
  belongs_to :supplier
  belongs_to :measurement

  has_many :ingredients, dependent: :destroy

  validates :article, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true, uniqueness: { scope: :supplier, case_sensitive: false }

  scope :raw_products, ->() { joins(:category).where(categories: { kind: :raw_product }) }

  def display_label
    "#{ name } (#{ measurement.unit })"
  end
end
