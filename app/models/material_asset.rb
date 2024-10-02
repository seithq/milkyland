class MaterialAsset < ApplicationRecord
  belongs_to :category
  belongs_to :supplier
  belongs_to :measurement

  has_many :ingredients, dependent: :destroy
  has_many :containers, dependent: :destroy

  has_many :products, dependent: :destroy
  has_many :box_packagings, dependent: :destroy

  validates :article, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true, uniqueness: { scope: :supplier, case_sensitive: false }

  scope :raw_products, ->() { joins(:category).merge(Category.raw_products) }
  scope :packings, ->() { joins(:category).merge(Category.packings) }

  def display_label
    "#{ name } (#{ measurement.unit })"
  end
end
